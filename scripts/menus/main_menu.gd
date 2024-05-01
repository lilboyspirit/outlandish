extends Node


func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		_on_quit()


func _on_start():
	pass # Replace with function body.


func _on_settings():
	pass # Replace with function body.


func _on_quit():
	get_tree().quit()
