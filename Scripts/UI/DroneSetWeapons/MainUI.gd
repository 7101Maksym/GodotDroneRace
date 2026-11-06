extends Control

@onready var _drones : HBoxContainer = $SetDroneMenu/Drones
@onready var _droneNameLabel : Label = $SetDroneMenu/DroneInform/Name
@onready var _max_weight : Label = $SetDroneMenu/DroneInform/Parametrs/Mass/Label
@onready var _droneLevelLabel : Label = $SetDroneMenu/DroneInform/UpgradePanel/Level

var _currentDroneIdx : int = 1
var _countDrones : int = 0
@onready var _point : float = _drones.position.x

const DRONE_MOVE_SPEED : float = 2000

func ReloadMenu() -> void:
	_countDrones = 0
	for node in _drones.get_children():
		node.queue_free()
	
	#start loading drone set menu
	var dir = DirAccess.open("res://Scenes/UI/DronesTemplates/")
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if not dir.current_is_dir():
				_countDrones += 1
			file_name = dir.get_next()
	
	for i in range(1, _countDrones + 1):
		var drone : Drone = load("res://Scenes/UI/DronesTemplates/" + str(i) + ".tscn").instantiate()
		print("Loaded drone: " + str(drone.nameOfDrone))
		
		_drones.add_child(drone)
	
	#finish loading drone set menu
	print("Drones loaded succesfully")
	
	SetDroneData()
	_set_drone_level()
	
func _set_drone_level() -> void:
	_droneLevelLabel.text = str(_get_current_drone().Level)
	
#functions for SetDroneMenu
func NextDrone() -> void:
	if _currentDroneIdx < _countDrones:
		_currentDroneIdx += 1
		_point -= _drones.get_child(_currentDroneIdx - 1).size.x
		_point -= _drones.get_theme_constant("separation")
	_update_purcases()
	_set_zero_data()

func PreviousDrone():
	if _currentDroneIdx > 1:
		_currentDroneIdx -= 1
		_point += _drones.get_child(_currentDroneIdx - 1).size.x
		_point += _drones.get_theme_constant("separation")
	_update_purcases()
	_set_zero_data()

func MoveDrones(delta : float):
	if (abs(_point - _drones.position.x) < 20):
		_drones.position.x = _point
		SetDroneData()
		return
	
	if (_point < _drones.position.x):
		_drones.position.x -= DRONE_MOVE_SPEED * delta
	elif (_point > _drones.position.x):
		_drones.position.x += DRONE_MOVE_SPEED * delta

func SetDroneData():
	$SetDroneMenu/Lock.show()
	_droneNameLabel.show()
	$SetDroneMenu/DroneInform/UpgradePanel.show()
	_droneLevelLabel.show()
	$SetDroneMenu/DroneInform/Parametrs.show()
	
	var drone : Drone = _get_current_drone()
	if (drone == null):
		return
	var res = load("res://Resources/DroneData/" + str(drone.nameOfDrone) + ".tres")
	
	_droneNameLabel.text_auto_shrink = tr(str(drone.nameOfDrone) + "_NAME")
	
	$SetDroneMenu/DroneInform/Parametrs/HP/Label.text_auto_shrink = str(drone.Healths)
	$SetDroneMenu/DroneInform/Parametrs/Speed/Label.text_auto_shrink = str(drone.Speed)
	_max_weight.text = str(res.max_weight)
	
	_update_purcases()
	_set_drone_level()
	$SetDroneMenu/DroneInform/UpgradePanel.SetCurrentDrone(drone)
#functions for SetWeaponMenu

func _physics_process(delta: float) -> void:
	MoveDrones(delta)

func _get_current_drone() -> Drone:
	if (_drones.get_child_count() != 0):
		return _drones.get_child(_currentDroneIdx - 1)
	else:
		return null

func _set_zero_data() -> void:
	$SetDroneMenu/Lock.hide()
	_droneNameLabel.hide()
	$SetDroneMenu/DroneInform/UpgradePanel.hide()
	_droneLevelLabel.hide()
	$SetDroneMenu/DroneInform/Parametrs.hide()
	$SetDroneMenu/DroneInform/BuyPanel.hide()

func _update_purcases() -> void:
	if (!PlayerData.Load("Purcases_drones", str(_get_current_drone().nameOfDrone), false)):
		$SetDroneMenu/Lock.show()
		$SetDroneMenu/ChangeWeapons.disabled = true
		$SetDroneMenu/DroneInform/BuyPanel.show()
		$SetDroneMenu/DroneInform/UpgradePanel.hide()
		_set_buy_panel_data()
	else:
		$SetDroneMenu/Lock.hide()
		$SetDroneMenu/ChangeWeapons.disabled = false
		$SetDroneMenu/DroneInform/BuyPanel.hide()
		$SetDroneMenu/DroneInform/UpgradePanel.show()

func _set_buy_panel_data() -> void:
	$SetDroneMenu/DroneInform/BuyPanel.UpdatePanel(_get_current_drone().nameOfDrone)

func _on_change_weapons_pressed() -> void:
	$SetDroneMenu.hide()
	$SetWeaponsMenu.show()
	$SetWeaponsMenu.MenuOpened(str(_get_current_drone().nameOfDrone))

func _on_confirm_weapons_button_pressed() -> void:
	$SetWeaponsMenu.hide()
	ReloadMenu()
	$SetWeaponsMenu/WeaponInfo.hide()
	$SetDroneMenu.show()

func _on_drone_setting_pressed() -> void:
	ReloadMenu()
	$SetDroneMenu.show()
	$WorkshopBackground.show()

func _on_confirm_changes_button_pressed() -> void:
	$SetDroneMenu.hide()
	$WorkshopBackground.hide()
	$StartUI.show()
