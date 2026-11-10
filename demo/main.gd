extends Control

var _status: Label
var _score_input: SpinBox

func _ready() -> void:
	var layout := VBoxContainer.new()
	layout.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	layout.custom_minimum_size = Vector2(440, 300)
	layout.add_theme_constant_override("separation", 12)
	add_child(layout)
	var title := Label.new()
	title.text = "PixelPilot Toolkit Demo"
	title.add_theme_font_size_override("font_size", 26)
	layout.add_child(title)
	var description := Label.new()
	description.text = "Save a score, load it again, or try the settings panel."
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	layout.add_child(description)
	_score_input = SpinBox.new()
	_score_input.min_value = 0
	_score_input.max_value = 999999
	_score_input.value = 1250
	layout.add_child(_score_input)
	var save_button := Button.new()
	save_button.text = "Save score to Slot 1"
	save_button.pressed.connect(_save_score)
	layout.add_child(save_button)
	var load_button := Button.new()
	load_button.text = "Load score from Slot 1"
	load_button.pressed.connect(_load_score)
	layout.add_child(load_button)
	var settings_button := Button.new()
	settings_button.text = "Open settings"
	settings_button.pressed.connect(_open_settings)
	layout.add_child(settings_button)
	_status = Label.new()
	_status.text = "Ready. Change the score and press Save."
	_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	layout.add_child(_status)

func _save_score() -> void:
	var success: bool = SaveManager.save_game(1, {"score": int(_score_input.value)})
	_status.text = "Score saved." if success else "Save failed. Check the Output panel."

func _load_score() -> void:
	var data: Dictionary = SaveManager.load_game(1)
	if data.is_empty():
		_status.text = "No valid save found in Slot 1."
		return
	_score_input.value = int(data.get("score", 0))
	_status.text = "Loaded score: %d" % int(_score_input.value)

func _open_settings() -> void:
	get_tree().change_scene_to_file("res://demo/settings_demo.tscn")
