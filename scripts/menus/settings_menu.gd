extends Node


var in_game : bool = false
var game_tab := preload("res://scenes/menus/game_settings_tab.tscn")


func _ready():
	if in_game:
		# TODO: adjust game settings based on game data
		$TabContainer.add_child(game_tab.instantiate())
	
	# TODO: load saved settigns
	# TODO: adjust settings based on saved settings


func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		_on_back()


func _on_back():
	# TODO: save settings
	queue_free()
