extends Control
class_name Empty

signal setted(node : Control)

func _on_button_pressed() -> void:
	emit_signal("setted", get_parent())
