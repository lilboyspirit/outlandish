extends Node


var settings_menu = preload("res://scenes/menus/settings_menu.tscn")


func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		_on_quit()


func _on_start():
	pass # Replace with function body.


func _on_settings():
	if !has_node("settings_menu"):
		add_child(settings_menu.instantiate())


func _on_quit():
	get_tree().quit()
