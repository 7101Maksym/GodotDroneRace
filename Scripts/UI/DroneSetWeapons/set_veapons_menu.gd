extends CanvasLayer

@onready var _droneContainer : Control = $Drone
@onready var _weaponsToSet : HBoxContainer = $WeaponsToSet/ScrollContainer/HBoxContainer
@onready var _weapon_info : NinePatchRect = $WeaponInfo
@onready var _mass_panel : NinePatchRect = $WeightPanel

var _drone : Drone = null
var _currentGunPoint : Control = null

func MenuOpened(id : String) -> void:
	for i in _droneContainer.get_children():
		i.queue_free()
	for i in _weaponsToSet.get_children():
		i.queue_free()
	
	if (!_mass_panel.is_owerweight.is_connected(IsOwerweight)):
		_mass_panel.is_owerweight.connect(IsOwerweight)
	
	for i in DirAccess.get_files_at("res://Scenes/UI/DronesTemplates/"):
		if i.contains(id):
			_drone = load("res://Scenes/UI/DronesTemplates/" + i.trim_suffix(".remap")).instantiate()
			_drone.mass_changed.connect(_mass_panel.SetMass)
			_droneContainer.add_child(_drone)
			break
	
	#Loading weapons that can be installed on this drone
	var weapons = _drone.GetWeapons()
	
	#regex needed only for finding icon
	var expr : RegEx = RegEx.new()
	expr.compile("#.+")
	
	for i in weapons:
		if (load("res://Resources/WeaponsData/" + expr.sub(i, "") + ".tres").cost_in == 2):
			PlayerData.Save("My weapons", expr.sub(i, ""), true)
	
	weapons.sort_custom(_custom_sort_of_weapons)
	
	for i in weapons:
		if i == "Empty.tscn":
			continue
		
		var img = preload("res://Scenes/UI/weapon_slot.tscn").instantiate()
		_weaponsToSet.add_child(img)
		img.SetMyWeapon(i)
		i = expr.sub(i, "")
		img.SetIcon(load("res://Resources/WeaponsData/" + i + ".tres").icon)
		img.connect("set_weapon", SetWeaponPressed)

func SetWeaponPressed(weapon_name) -> void:
	var expr : RegEx = RegEx.new()
	expr.compile("#.+")
	if(!PlayerData.Load("My weapons", expr.sub(weapon_name, ""), false)):
		_currentGunPoint = null
	
	if _currentGunPoint != null:
		_drone.SetWeapon(weapon_name, _currentGunPoint.name)
		await get_tree().process_frame
		_set_description_of_gun(_currentGunPoint.get_child(0).name)
	else:
		_set_description_of_gun(weapon_name, true)

func _input(event: InputEvent) -> void:
	if _currentGunPoint == null:
		return
	
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		# Нам нужно только событие начала касания (нажатия)
		if event.is_pressed():
			# Получаем глобальные координаты клика/касания
			var touch_position = event.position
			
			# Проверяем, находится ли точка касания внутри границ этого UI-элемента
			if _weapon_info.get_global_rect().has_point(touch_position):
				return
			
			for i in _currentGunPoint.get_children(true):
				if i.get_global_rect().has_point(touch_position):
					return
			
			for i in _weaponsToSet.get_children(true):
				if i.get_global_rect().has_point(touch_position):
					return
			
			_weapon_info.hide()
			_currentGunPoint = null

func _set_description_of_gun(gun_name : String, zero_pos : bool = false):
	if zero_pos:
		_weapon_info.SetDescription(gun_name, Vector2.ZERO)
		return
	_weapon_info.SetDescription(gun_name, _currentGunPoint.global_position)

func SetCurrentGunPoint(point : Control):
	_currentGunPoint = point
	_set_description_of_gun(point.get_child(0).name)

func WeaponHasBought() -> void:
	for i in _weaponsToSet.get_children():
		i.CheckWeapon()

func IsOwerweight(is_owerweight : bool) -> void:
	$Confirm.disabled = is_owerweight

func _on_delete_weapon_pressed() -> void:
	if _currentGunPoint != null:
		_drone.SetEmpty(_currentGunPoint.name)
		await get_tree().process_frame
		_set_description_of_gun(_currentGunPoint.get_child(0).name)

func _custom_sort_of_weapons(a : String, b : String) -> bool:
	if (PlayerData.Load("My weapons", a, false) > PlayerData.Load("My weapons", b, false)):
		return true
	elif (PlayerData.Load("My weapons", a, false) < PlayerData.Load("My weapons", b, false)):
		return false
	
	#regex needed only for finding resource
	var expr : RegEx = RegEx.new()
	expr.compile("#.+")
	
	a = expr.sub(a, "")
	b = expr.sub(b, "")
	
	var r_a : WeaponData = load("res://Resources/WeaponsData/" + a + ".tres")
	var r_b : WeaponData = load("res://Resources/WeaponsData/" + b + ".tres")
	
	if (r_a.cost_in == 2):
		return true
	if (r_b.cost_in == 2):
		return false
	
	if (r_a.cost_in == 3):
		return false
	
	if (r_b.cost_in == 3):
		if (r_a.cost_in == 3):
			return false
		else:
			return true
	
	if (r_a.cost_in == 1 && r_b.cost_in == 0):
		return true
	elif (r_a.cost_in == 0 && r_b.cost_in == 1):
		return false
	
	if (r_a.cost < r_b.cost):
		return true
	else:
		return false
