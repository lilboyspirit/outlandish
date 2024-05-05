extends Node


signal general_settings_updated


# General
var power_saving: bool = false :
	set(value):
		power_saving = value
		emit_signal("general_settings_updated")
	get:
		return power_saving


func _ready():
	_on_general_settings_updated()
	connect("general_settings_updated", _on_general_settings_updated)


func _on_general_settings_updated():
	OS.low_processor_usage_mode = power_saving
