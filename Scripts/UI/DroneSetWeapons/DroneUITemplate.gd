extends Control
class_name Drone

@export var Points : Dictionary[String, Control]
##index of drone in game system
@export var nameOfDrone : int = 1
##Scale that be applied for weapons
@export var scaleOfDrone : float = 1
var _baseHealths : float = 10
var _baseSpeed : float = 10
var _max_mass : int = 10

var Weight : int = 0
var Healths : int
var Speed : float
var Level : int

const BASE_SIZE : int = 188

signal mass_changed(current, max)

func _ready():
	Level = LevelManager.GetDroneLevel(str(nameOfDrone))
	_set_parametrs()
	_check_purcases()
	
	LoadDroneWeapons()
	ResizeWeapons()
	_mass_changed()

func ResizeWeapons() -> void:
	for j in Points:
		Points.get(j).scale = Vector2(size.y / BASE_SIZE, size.y / BASE_SIZE)

func LoadDroneWeapons() -> void:
	var _weapons : Dictionary = {}
	#PlayerData.Delete("Weapons", str(nameOfDrone)) #  Uncomment it if some files be changed
	_weapons = PlayerData.Load("Weapons",str(nameOfDrone), {})
	if _weapons != null && !_weapons.is_empty():
		for i in _weapons: #i - the name of point
			if (_weapons[i].trim_suffix(".remap") != "Empty.tscn"):
				SetWeapon(_weapons[i].trim_suffix(".remap"), i, false)
			else:
				SetEmpty(i)
	else:
		var data : Dictionary[String, String] = {}
		
		for i in Points.keys():
			data[i] = "Empty.tscn"
		
		PlayerData.Save("Weapons", name, data)

##name_of_gun - is the name in memory, i - the name of point.
func SetWeapon(name_of_gun : String, i, use_weight : bool = true) -> void:
	var current_weapons : Dictionary = PlayerData.Load("Weapons", str(nameOfDrone), "")
	var gun : Weapon = load("res://Scenes/UI/WeaponsTemplates/" + name_of_gun).instantiate()
	
	if use_weight && current_weapons[i] != "Empty.tscn":
		var del_gun = current_weapons[i]
		var expr : RegEx = RegEx.new()
		expr.compile("#.+")
		del_gun = expr.sub(del_gun, "")
		Weight -= load("res://Resources/WeaponsData/" + del_gun + ".tres").weight
	
	for child in Points[i].get_children():
		child.name = "Deletable"
		child.queue_free()
	
	var name_to_save = name_of_gun
	
	#regex needed only for finding resource
	var expr : RegEx = RegEx.new()
	expr.compile("#.+")
	name_of_gun = expr.sub(name_of_gun, "")
	var gun_res = load("res://Resources/WeaponsData/" + name_of_gun + ".tres")
	Weight += gun_res.weight
	_mass_changed()
	
	if current_weapons.get(i) != name_to_save:
		current_weapons[i] = name_to_save
		
		PlayerData.Save("Weapons", str(nameOfDrone), current_weapons)
	
	Points[i].add_child(gun)
	gun.connect("setted", _gunPressed)
	
	gun.scale = Vector2(scaleOfDrone, scaleOfDrone)
	
	if (i.contains("Side")):
		gun.SetSide()
	elif (i.contains("Bottom")):
		gun.SetBottom()
	elif (i.contains("Top")):
		gun.SetTop()

##i - the name of point.
func SetEmpty(i) -> void:
	var target = get_parent().get_parent()
	if (target.name == "SetDroneMenu"):
		return
	
	var current_weapons : Dictionary = PlayerData.Load("Weapons", str(nameOfDrone), "")
	
	var emp : Empty = load("res://Scenes/UI/WeaponsTemplates/Empty.tscn").instantiate()
	
	for child in Points[i].get_children():
		child.name = "Deletable"
		child.queue_free()
	
	if current_weapons.get(i) != "Empty.tscn":
		#regex needed only for finding resource
		var name_of_gun = current_weapons[i]
		var expr : RegEx = RegEx.new()
		expr.compile("#.+")
		name_of_gun = expr.sub(name_of_gun, "")
		
		var gun_res = load("res://Resources/WeaponsData/" + name_of_gun + ".tres")
		Weight -= gun_res.weight
		_mass_changed()
		
		current_weapons[i] = "Empty.tscn"
		
		PlayerData.Save("Weapons", str(nameOfDrone), current_weapons)
	
	Points[i].add_child(emp)
	emp.connect("setted", _gunPressed)
	
	emp.scale = Vector2(scaleOfDrone, scaleOfDrone)

func _mass_changed() -> void:
	emit_signal("mass_changed", Weight, _max_mass)

func _set_parametrs() -> void:
	var res = load("res://Resources/DroneData/" + str(nameOfDrone) + ".tres")
	_baseHealths = res.base_healths
	_baseSpeed = res.base_speed
	_max_mass = res.max_weight
	
	Healths = int(remap(Level, 1, 30, _baseHealths, _baseHealths * 5))
	Speed = float(String.num(float(remap(Level, 1, 30, _baseSpeed, _baseSpeed * 1.5)), 1))

func LevelUp() -> void:
	Level += 1
	LevelManager.UpgradeDrone(str(nameOfDrone))
	_set_parametrs()

##Returned weapons names, that can be installed on this drone. Name is a name of file in memory and can be used in any path.
func GetWeapons() -> Array[String]:
	var v : Array[String] = []
	
	var path : String = "res://Scenes/UI/WeaponsTemplates/"
	
	for i in DirAccess.get_files_at(path):
		if (i.contains("#" + str(nameOfDrone) + "#")):
			v.append(i.trim_suffix(".remap"))
	
	return v

func _gunPressed(point : Control):
	var target = get_parent().get_parent()
	if (target.name != "SetDroneMenu"):
		target.SetCurrentGunPoint(point)

func _check_purcases() -> void:
	var res = load("res://Resources/DroneData/" + str(nameOfDrone) + ".tres")
	
	if (res.cost_in == "Free"):
		PlayerData.Save("Purcases_drones", str(nameOfDrone), true)
	
	if (!PlayerData.Load("Purcases_drones", str(nameOfDrone), false)):
		$PD_UI.modulate = Color.BLACK
