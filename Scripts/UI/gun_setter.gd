extends Control

@onready var MyButton : Button = $StartImage/Button

func _ready() -> void:
	visible = false

func SetTarget(t : Vector2):
	$Line2D.points[0] = position
	$Line2D.points[1] = t
	$EndImage.position = t
	visible = true
