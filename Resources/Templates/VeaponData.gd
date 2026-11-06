class_name WeaponData
extends Resource

##Damage of one bullet or per one second.
@export var damage : int
##Count of bullets that must be shooted after pressing button or max length in seconds of continuously shooting.
@export var damagesPerShoot : int
##Time of full reload in seconds.
@export var reloadTime : float
@export var isContinious : bool
##Key of name in translate system.
@export var name : String
@export var icon : AtlasTexture
@export var weight : int
@export_enum("Gems", "Coins", "Free", "Special") var cost_in
@export var cost : int
