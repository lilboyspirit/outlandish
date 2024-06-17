extends Node


const path := "user://config.json"


signal general_settings_updated


func _ready():
	await load_config()
	_on_general_settings_updated()
	connect("general_settings_updated", _on_general_settings_updated)


func save_config():
	var data : Dictionary = {}
	
	for i : Dictionary in self.get_property_list():
		const exclude : Array[String] = ["Settings.gd", "Node", "_import_path", "name", "unique_name_in_owner", "scene_file_path", "owner", "multiplayer", "Process", "process_mode", "process_priority", "process_physics_priority", "Thread Group", "process_thread_group", "process_thread_group_order", "process_thread_messages", "Editor Description", "editor_description", "script"]
		if exclude.has(i.name):
			continue
		
		data[i.name] = self.get(i.name)
	
	await fs.save_json(path, data)


func load_config():
	return await fs.load_json(path, self)


func _on_general_settings_updated():
	OS.low_processor_usage_mode = power_saving


# General
var power_saving: bool = false :
	set(value):
		power_saving = value
		emit_signal("general_settings_updated")
	get:
		return power_saving
