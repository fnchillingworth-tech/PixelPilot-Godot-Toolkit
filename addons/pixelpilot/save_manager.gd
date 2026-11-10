extends Node
## Numbered-slot JSON save system with version checking.

signal save_completed(slot: int)
signal save_failed(slot: int, reason: String)

const SAVE_DIR := "user://pixelpilot_saves"
const SAVE_VERSION := 1

func save_game(slot: int, data: Dictionary) -> bool:
	if slot < 1:
		save_failed.emit(slot, "Slot numbers must be 1 or higher.")
		return false
	var absolute_dir := ProjectSettings.globalize_path(SAVE_DIR)
	var dir_error := DirAccess.make_dir_recursive_absolute(absolute_dir)
	if dir_error != OK:
		save_failed.emit(slot, "Could not create save directory (error %d)." % dir_error)
		return false
	var payload := {"version": SAVE_VERSION, "saved_at": Time.get_datetime_string_from_system(), "data": data}
	var target := _slot_path(slot)
	var temporary := target + ".tmp"
	var file := FileAccess.open(temporary, FileAccess.WRITE)
	if file == null:
		save_failed.emit(slot, "Could not open temporary save file (error %d)." % FileAccess.get_open_error())
		return false
	file.store_string(JSON.stringify(payload, "\t"))
	file.flush()
	file.close()
	if FileAccess.file_exists(target):
		var remove_error := DirAccess.remove_absolute(ProjectSettings.globalize_path(target))
		if remove_error != OK:
			save_failed.emit(slot, "Could not replace previous save (error %d)." % remove_error)
			return false
	var rename_error := DirAccess.rename_absolute(ProjectSettings.globalize_path(temporary), ProjectSettings.globalize_path(target))
	if rename_error != OK:
		save_failed.emit(slot, "Could not finalise save file (error %d)." % rename_error)
		return false
	save_completed.emit(slot)
	return true

func load_game(slot: int) -> Dictionary:
	if slot < 1:
		return {}
	var path := _slot_path(slot)
	if not FileAccess.file_exists(path):
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_warning("PixelPilot: unable to read slot %d." % slot)
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(parsed) != TYPE_DICTIONARY or int(parsed.get("version", -1)) != SAVE_VERSION:
		push_warning("PixelPilot: slot %d is invalid or uses an unsupported version." % slot)
		return {}
	var data: Variant = parsed.get("data", {})
	return data if typeof(data) == TYPE_DICTIONARY else {}

func delete_save(slot: int) -> bool:
	if slot < 1:
		return false
	var path := _slot_path(slot)
	if not FileAccess.file_exists(path):
		return true
	return DirAccess.remove_absolute(ProjectSettings.globalize_path(path)) == OK

func get_slot_info(slot: int) -> Dictionary:
	if slot < 1:
		return {}
	var path := _slot_path(slot)
	if not FileAccess.file_exists(path):
		return {"exists": false}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {"exists": true, "valid": false}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(parsed) != TYPE_DICTIONARY:
		return {"exists": true, "valid": false}
	return {"exists": true, "valid": int(parsed.get("version", -1)) == SAVE_VERSION, "saved_at": str(parsed.get("saved_at", "Unknown"))}

func _slot_path(slot: int) -> String:
	return "%s/slot_%d.json" % [SAVE_DIR, slot]
