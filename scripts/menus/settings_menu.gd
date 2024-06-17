extends Node


var in_game : bool = false
var game_tab := preload("res://scenes/menus/game_settings_tab.tscn")


func _ready():
	if in_game:
		# TODO: adjust game settings based on game data
		$TabContainer.add_child(game_tab.instantiate())

	_on_general_settings_updated()
	Settings.connect("general_settings_updated", _on_general_settings_updated)


func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		_on_back()


func _on_back():
	await Settings.save_config()
	queue_free()


func _on_general_settings_updated():
	%power_saving.button_pressed = Settings.power_saving


func _on_power_saving_toggled(toggled_on: bool):
	Settings.power_saving = toggled_on
