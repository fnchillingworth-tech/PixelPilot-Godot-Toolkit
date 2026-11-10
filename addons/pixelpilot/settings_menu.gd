extends Control
## Optional runtime-built settings panel. Attach to a Control node.

@export var panel_title := "Game Settings"
var _settings: Node

func _ready() -> void:
	_settings = get_node_or_null("/root/SettingsManager")
	if _settings == null:
		push_error("PixelPilot: configure SettingsManager as an Autoload first.")
		return
	_build_interface()

func _build_interface() -> void:
	var panel := PanelContainer.new()
	panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	panel.custom_minimum_size = Vector2(420, 260)
	add_child(panel)
	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 14)
	panel.add_child(layout)
	var heading := Label.new()
	heading.text = panel_title
	heading.add_theme_font_size_override("font_size", 24)
	layout.add_child(heading)
	var volume_label := Label.new()
	volume_label.text = "Master volume"
	layout.add_child(volume_label)
	var volume := HSlider.new()
	volume.min_value = 0.0
	volume.max_value = 1.0
	volume.step = 0.01
	volume.value = _settings.get_master_volume()
	volume.value_changed.connect(_on_volume_changed)
	layout.add_child(volume)
	var fullscreen := CheckButton.new()
	fullscreen.text = "Fullscreen"
	fullscreen.button_pressed = _settings.is_fullscreen()
	fullscreen.toggled.connect(_on_fullscreen_toggled)
	layout.add_child(fullscreen)
	var vsync := CheckButton.new()
	vsync.text = "Vertical sync"
	vsync.button_pressed = _settings.is_vsync_enabled()
	vsync.toggled.connect(_on_vsync_toggled)
	layout.add_child(vsync)

func _on_volume_changed(value: float) -> void:
	_settings.set_master_volume(value)

func _on_fullscreen_toggled(enabled: bool) -> void:
	_settings.set_fullscreen(enabled)

func _on_vsync_toggled(enabled: bool) -> void:
	_settings.set_vsync_enabled(enabled)
