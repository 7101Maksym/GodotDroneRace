extends Node2D
class_name Bullet

var BulletDirection : int
var Speed : float

func _ready() -> void:
	for node in get_children(true):
		if (node.is_in_group("healths_objects")):
			node.connect("dead", Stop)

func _physics_process(delta: float) -> void:
	position += Vector2.from_angle(rotation).normalized() * BulletDirection * Speed * delta

func Stop() -> void:
	Speed = 0
