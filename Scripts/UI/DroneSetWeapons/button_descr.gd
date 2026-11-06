extends Button

@export var _my_description : Label

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch && event.pressed:
		if not get_global_rect().has_point(event.position):
			_my_description.hide()

func _on_pressed() -> void:
	_my_description.show()
