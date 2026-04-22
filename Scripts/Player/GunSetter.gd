extends Node2D

@export var _weapons : Array[PackedScene]
@export var _points : Array[Node2D]
@export var _droneId : int

@onready var _buttons : VBoxContainer = NodeGetter.ButtonsContainer

func _ready():
	_weapons = WeaponsSetter.Weapons.get(_droneId, [])
	
	for i in _weapons.size():
		if (_weapons[i] != null && _points[i] != null):
			var gun = _weapons[i].instantiate()
			var button = _buttons.AddButton(gun.MyImage, gun.Shoot)
			_points[i].add_child(gun)
			gun.SetIndicator(button.Indicator)
