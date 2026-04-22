extends Node

const PATH : String = "user://drone_save_game.cfg"

func _ready() -> void:
	pass

func Save(section, key, data):
	var file : ConfigFile = ConfigFile.new()
	
	file.load(PATH)
	
	file.set_value(section, key, data)
	
	file.save(PATH)

func Load(section, key):
	var file : ConfigFile = ConfigFile.new()
	
	var err = file.load(PATH)
	
	if err == OK:
		return file.get_value(section, key)
	else:
		return null
