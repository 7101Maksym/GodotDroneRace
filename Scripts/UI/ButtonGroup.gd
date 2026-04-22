extends VBoxContainer

func _ready() -> void:
	NodeGetter.ButtonsContainer = self

func AddButton(img : AtlasTexture, event : Callable):
	var button = preload("res://Scenes/UI/ShootButton.tscn").instantiate()
	
	button.icon = img
	button.connect("pressed", event)
	
	add_child(button)
	
	queue_sort()
	
	return button

func _exit_tree() -> void:
	NodeGetter.ButtonsContainer = null
