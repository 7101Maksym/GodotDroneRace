extends Control

@onready var _field : TextureRect = $Field
@onready var _button : TextureRect = $Field/Button

var _joysticPos : Vector2 = Vector2.ZERO
var _tIndex = -1

func _input(event: InputEvent) -> void:
	if (event is InputEventScreenTouch && _joysticPos == Vector2.ZERO):
		_joysticPos = event.position
		_tIndex = event.index
		_field.position = _joysticPos
