extends SceneTree

func _initialize() -> void:
	call_deferred("_run_tests")

func _run_tests() -> void:
	var passed := true
	var manager_script: Script = load("res://addons/pixelpilot/save_manager.gd")
	var manager: Node = manager_script.new()
	root.add_child(manager)
	var test_data := {"score": 4321, "level": 7, "inventory": ["key", "potion"]}
	var saved: bool = manager.save_game(9876, test_data)
	passed = passed and saved
	var loaded: Dictionary = manager.load_game(9876)
	passed = passed and int(loaded.get("score", -1)) == 4321
	passed = passed and int(loaded.get("level", -1)) == 7
	passed = passed and loaded.get("inventory", []) == ["key", "potion"]
	var info: Dictionary = manager.get_slot_info(9876)
	passed = passed and bool(info.get("exists", false)) and bool(info.get("valid", false))
	passed = passed and manager.delete_save(9876)
	passed = passed and manager.load_game(9876).is_empty()
	if passed:
		print("PIXELPILOT SMOKE TESTS: PASS")
	else:
		push_error("PIXELPILOT SMOKE TESTS: FAIL")
	quit(0 if passed else 1)
