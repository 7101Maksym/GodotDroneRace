extends Node

var GunLevels : Dictionary = {}

func _ready() -> void:
	GunLevels = PlayerData.Load("GunData", "GunLevels", {})

func LevelUp(name_of_gun : String):
	if (GunLevels[name_of_gun] < 30):
		GunLevels[name_of_gun] += 1
		PlayerData.Save("GunData", "GunLevels", GunLevels)
		return OK

func GetLevel(name_of_gun : String) -> int:
	return GunLevels[name_of_gun]
