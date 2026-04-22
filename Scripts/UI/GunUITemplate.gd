extends TextureRect

@export var DefaultTexture : AtlasTexture
@export_flags("top", "bottom", "side") var Type : int

@export_group("Textures")
@export var Top : AtlasTexture
@export var Bottom : AtlasTexture
@export var SideTexture : AtlasTexture

@export_group("Pivot offsets")
@export var TopOffset : Vector2
@export var BottomOffset : Vector2
@export var SideOffset : Vector2

func SetTop() -> void:
	texture = Top
	pivot_offset = TopOffset

func SetBottom() -> void:
	texture = Bottom
	pivot_offset = BottomOffset

func SetSide() -> void:
	texture = SideTexture
	pivot_offset = SideOffset
