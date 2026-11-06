extends NinePatchRect

@onready var mass : Label = $Mass/Label

signal is_owerweight(is_owerweight)

func SetMass(current_mass : int, max_mass : int) -> void:
	mass.text_auto_shrink = str(current_mass) + "/" + str(max_mass)
	if (current_mass > max_mass):
		mass.modulate = Color(1.0, 0.0, 0.0, 1.0)
		$AnimationPlayer.play("Show")
		emit_signal("is_owerweight", true)
	else:
		mass.modulate = Color(1.0, 1.0, 1.0, 1.0)
		emit_signal("is_owerweight", false)
