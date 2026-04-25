extends Control

@onready var _image : TextureRect = $GunImage

@export var DefaultTexture : AtlasTexture
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

func SetTop() -> void:
	_image.texture = Top
	_image.position = -_topPoint
	_image.pivot_offset = _topPoint
	_image.scale.x = _scale
	_image.scale.y = _scale

func SetBottom() -> void:
	_image.texture = Bottom
	_image.position = -_bottomPoint
	_image.pivot_offset = _bottomPoint
	_image.scale.x = _scale
	_image.scale.y = _scale

func SetSide() -> void:
	_image.texture = SideTexture
	_image.position = -_sidePoint
	_image.pivot_offset = _sidePoint
	_image.scale.x = _scale
	_image.scale.y = _scale
