extends Node

var PATH : String = "user://drone_save_game.cfg"
var _current_file : ConfigFile = ConfigFile.new()
var err

func _ready() -> void:
	err = _current_file.load(PATH)

func Save(section : String, key : String, data):
	var file : ConfigFile = ConfigFile.new()
	file.load(PATH)
	file.set_value(section, key, data)
	file.save(PATH)
	err = _current_file.load(PATH)

func Load(section : String, key : String, default):
	if err == OK:
		return _current_file.get_value(section, key, default)
	else:
		print("Empty value: " + section + ", " + key + " on path " + PATH)
		return default

func Delete(section : String, key : String = ""):
	if (key != ""):
		Save(section, key, null)
	else:
		var file : ConfigFile = ConfigFile.new()
		file.load(PATH)
		file.erase_section(section)
		file.save(PATH)
		err = _current_file.load(PATH)
