extends Control
class_name Weapon

@onready var _image : TextureRect = $GunImage

@export_flags("top", "bottom", "side") var Type : int
@export var _scale : float = 1

@export_group("Textures")
@export var Top : AtlasTexture
@export var Bottom : AtlasTexture
@export var SideTexture : AtlasTexture

@export_group("Points")
@export var _bottomPoint : Vector2
@export var _sidePoint : Vector2
@export var _topPoint : Vector2

signal setted(node : Control)

func _ready() -> void:
	_image.texture = null
	_image.size = Vector2.ZERO
	
	for i in find_children("*", "Button", true, false):
		i.pressed.connect(_on_button_pressed)
		break

func SetTop() -> bool:
	if (Top == null):
		return false
	
	_image.texture = Top
	_image.position = -_topPoint
	_image.pivot_offset = _topPoint
	_image.scale.x = _scale
	_image.scale.y = _scale
	return true

func SetBottom() -> bool:
	if (Bottom == null):
		return false
	
	_image.texture = Bottom
	_image.position = -_bottomPoint
	_image.pivot_offset = _bottomPoint
	_image.scale.x = _scale
	_image.scale.y = _scale
	return true

func SetSide() -> bool:
	if (SideTexture == null):
		return false
	
	_image.texture = SideTexture
	_image.position = -_sidePoint
	_image.pivot_offset = _sidePoint
	_image.scale.x = _scale
	_image.scale.y = _scale
	return true

func _on_button_pressed() -> void:
	emit_signal("setted", get_parent())
