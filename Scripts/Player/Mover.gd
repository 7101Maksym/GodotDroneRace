extends CharacterBody2D

@export var Speed : float

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _on_virtual_joystick_direction_changed(input_direction: Vector2) -> void:
	if (input_direction.length() > 1):
		input_direction = input_direction.normalized()
	
	velocity = input_direction * Speed
