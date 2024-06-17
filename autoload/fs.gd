extends Node


const MAX_FILE_SIZE = 8388608  # in bytes


func load_json(path: String, object: Object = null):
	if !FileAccess.file_exists(path):
		push_error("File '%s' not found" % [path])
		return

	var file := FileAccess.open(path, FileAccess.READ)
	if !file:
		push_error("Failed to open file '%s'" % [path])
		return

	var size = file.get_length()
	if size > MAX_FILE_SIZE:
		file.close()
		push_error("File '%s' exceeds size limit by %s bytes" % [path, size - MAX_FILE_SIZE])
		return

	var data = await JSON.parse_string(file.get_as_text())

	file.close()

	if object:
		if data is Dictionary:
			for key in data:
				object.set(key, data[key])
		else:
			object.set(path.get_basename(), data)

	return data


func save_json(path: String, value):
	if !value:
		push_error("Not valid value to save as json" % [path])
		return

	if !DirAccess.dir_exists_absolute(path.get_base_dir()):
		print("making: '%s'" % [path.get_base_dir()])
		var make_dir_status = DirAccess.make_dir_recursive_absolute(path.get_base_dir())
		if make_dir_status:
			push_error("Failed to make dir '%s' [%s]" % [path.get_base_dir(), make_dir_status])

	var file := FileAccess.open(path, FileAccess.WRITE)
	if !file:
		file.close()
		push_error("Failed to open file to write '%s'" % [path])
		return

	file.store_line(JSON.stringify(value, "  "))

	file.close()
