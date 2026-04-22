extends Control

@onready var _drones : HBoxContainer = $SetDroneMenu/HBoxContainer

var _currentDroneIdx : int = 1
var _countDrones : int = 0
@onready var _point : float = _drones.position.x

const DRONE_MOVE_SPEED : float = 1000

func _ready() -> void:
	for node in _drones.get_children():
		node.queue_free()
	
	#start loading drone set menu
	var dir = DirAccess.open("res://Scenes/UI/DronesTemplates/")
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			# Проверяем, что это файл, а не подпапка
			if not dir.current_is_dir():
				_countDrones += 1
			file_name = dir.get_next()
	
	for i in range(1, _countDrones + 1):
		var drone = load("res://Scenes/UI/DronesTemplates/" + str(i) + ".tscn").instantiate()
		_drones.add_child(drone)
	#finish loading drone set menu
	print("Drones loaded succesfully")

func NextDrone() -> void:
	if _currentDroneIdx < _countDrones:
		_currentDroneIdx += 1
		_point -= _drones.get_child(_currentDroneIdx - 1).size.x
		_point -= _drones.get_theme_constant("separation")

func PreviousDrone():
	if _currentDroneIdx > 1:
		_currentDroneIdx -= 1
		_point += _drones.get_child(_currentDroneIdx - 1).size.x
		_point += _drones.get_theme_constant("separation")

func MoveDrones(delta : float):
	if (abs(_point - _drones.position.x) < 20):
		_drones.position.x = _point
	
	if (_point < _drones.position.x):
		_drones.position.x -= DRONE_MOVE_SPEED * delta
	elif (_point > _drones.position.x):
		_drones.position.x += DRONE_MOVE_SPEED * delta

func SetChangeVeapons():
	$SetDroneMenu.visible = false
	$SetVeaponsMenu.visible = true

func SetChangingDrone():
	$SetDroneMenu.visible = false
	$SetVeaponsMenu.visible = true

func _physics_process(delta: float) -> void:
	MoveDrones(delta)
	if (Input.is_action_just_pressed("ui_left")):
		NextDrone()
	elif (Input.is_action_just_pressed("ui_right")):
		PreviousDrone()
