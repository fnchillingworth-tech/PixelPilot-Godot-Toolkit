extends Node
## Persists audio and display settings using ConfigFile.

signal settings_changed

const SETTINGS_PATH := "user://pixelpilot_settings.cfg"
const DEFAULTS := {"master_volume": 0.8, "fullscreen": false, "vsync": true}
var _settings: Dictionary = DEFAULTS.duplicate(true)

func _ready() -> void:
	load_settings()

func load_settings() -> void:
	var config := ConfigFile.new()
	if config.load(SETTINGS_PATH) == OK:
		_settings["master_volume"] = clampf(float(config.get_value("audio", "master_volume", DEFAULTS.master_volume)), 0.0, 1.0)
		_settings["fullscreen"] = bool(config.get_value("display", "fullscreen", DEFAULTS.fullscreen))
		_settings["vsync"] = bool(config.get_value("display", "vsync", DEFAULTS.vsync))
	_apply_settings()

func save_settings() -> bool:
	var config := ConfigFile.new()
	config.set_value("audio", "master_volume", get_master_volume())
	config.set_value("display", "fullscreen", is_fullscreen())
	config.set_value("display", "vsync", is_vsync_enabled())
	var error := config.save(SETTINGS_PATH)
	if error != OK:
		push_error("PixelPilot: settings save failed (error %d)." % error)
		return false
	return true

func get_master_volume() -> float:
	return float(_settings.master_volume)

func set_master_volume(value: float) -> void:
	_settings.master_volume = clampf(value, 0.0, 1.0)
	_apply_audio()
	save_settings()
	settings_changed.emit()

func is_fullscreen() -> bool:
	return bool(_settings.fullscreen)

func set_fullscreen(enabled: bool) -> void:
	_settings.fullscreen = enabled
	_apply_display()
	save_settings()
	settings_changed.emit()

func is_vsync_enabled() -> bool:
	return bool(_settings.vsync)

func set_vsync_enabled(enabled: bool) -> void:
	_settings.vsync = enabled
	_apply_display()
	save_settings()
	settings_changed.emit()

func _apply_settings() -> void:
	_apply_audio()
	_apply_display()

func _apply_audio() -> void:
	var bus_index := AudioServer.get_bus_index("Master")
	if bus_index >= 0:
		var volume := get_master_volume()
		AudioServer.set_bus_mute(bus_index, volume <= 0.001)
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(maxf(volume, 0.001)))

func _apply_display() -> void:
	var mode := DisplayServer.WINDOW_MODE_FULLSCREEN if is_fullscreen() else DisplayServer.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(mode)
	var vsync_mode := DisplayServer.VSYNC_ENABLED if is_vsync_enabled() else DisplayServer.VSYNC_DISABLED
	DisplayServer.window_set_vsync_mode(vsync_mode)
