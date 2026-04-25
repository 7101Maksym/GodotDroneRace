extends Control

@export var Points : Dictionary[String, Control]
@export var LabelIdx : Dictionary[Control, int]
@export var nameOfDrone : String = ""

var Weapons = {}

func _ready():
	Weapons = PlayerData.Load("Weapons", nameOfDrone)
	
	if Weapons != null:
		for i in Weapons:
			print("res://Scenes/UI/WeaponsTemplates/" + nameOfDrone + "/" + Weapons[i])
			var gun = load("res://Scenes/UI/WeaponsTemplates/" + nameOfDrone + "/" + Weapons[i]).instantiate()
			
			Points[i].add_child(gun)
			
			if (i == "Side"):
				gun.SetSide()
			elif (i == "Bottom"):
				gun.SetBottom()
			elif (i == "Top"):
				gun.SetTop()
	else:
		var data : Dictionary[String, String] = {}
		
		for i in Points.keys():
			var path : String = "res://Scenes/UI/WeaponsTemplates/"
			data.get_or_add(i, DirAccess.get_files_at(path + name + '/')[0])

		PlayerData.Save("Weapons", name, data)

func SetWeapon(pos : String, weaponName : String):
	Points.get(pos).add_child(load("res://Scenes/UI/WeaponsTemplates/1/" + weaponName)).instantiate()
