extends Control

func _ready() -> void:
	var back := Button.new()
	back.text = "Back to demo"
	back.position = Vector2(24, 24)
	back.pressed.connect(_go_back)
	add_child(back)
	var settings := Control.new()
	settings.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	settings.set_script(load("res://addons/pixelpilot/settings_menu.gd"))
	add_child(settings)

func _go_back() -> void:
	get_tree().change_scene_to_file("res://demo/main.tscn")
