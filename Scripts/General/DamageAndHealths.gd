extends Area2D

@export var _root : Node2D
##If FALSE, object can't take any damage
@export var _damageble : bool = true
##If TRUE, object will be destroyed after first collision with another object
@export var _isBullet : bool = false
@export_group("Hit box settings")
@export var _maxDamage : float = 0
@export var _minDamage : float = 0
##If object is bullet this settings will be ignored
@export_group("Hurt box settings")
@export var _healths : float = 1
@export var _maxHealths : float = _healths
@export var _shield : float = 0
@export var _maxShield : float = _shield
##Speed of recovering shield in points per second
@export var _recoverShield : float = 0
@export_group("Animation settings")
@export var _sprite : AnimatedSprite2D
@export var _animationAliveName : String = ""
##When object will be genrated, his scale will be changed to this scale
@export var _animationAliveScale : float = 1
@export var _animationDeathName : String = ""
##When object will be destroyed, his scale will be changed to this scale
@export var _animationDeathScale : float = 1

signal dead

func _ready() -> void:
	self.connect("area_entered", Collided)
	
	if (_sprite != null):
		_sprite.play(_animationAliveName)
		_root.scale = Vector2(_animationAliveScale, _animationAliveScale)

func _process(delta: float) -> void:
	if (_shield < _maxShield):
		_shield += _recoverShield * delta
	
	if (_shield > _maxShield):
		_shield = _maxShield

func TakeDamage(damage : float) -> void:
	if (!_damageble):
		return
	
	_shield -= damage
	
	if (_shield < 0):
		_healths += _shield
		_shield = 0
	
	if (_healths < 0):
		Death()

func RecoverHealths(value : float):
	if (_healths < _maxHealths):
		_healths += value
	
	if (_healths > _maxHealths):
		_healths = _maxHealths

func Collided(area : Area2D) -> void:
	if (area.is_in_group("healths_objects")):
		area.TakeDamage(randf_range(_minDamage, _maxDamage))
		
	if (_isBullet):
		Death()

func Death() -> void:
	if (_sprite != null):
		_sprite.sprite_frames.set_animation_loop(_animationDeathName, false)
		_sprite.play(_animationDeathName)
		_root.scale = Vector2(_animationDeathScale, _animationDeathScale)
		_sprite.connect("animation_finished", _root.queue_free)
	else:
		_root.queue_free()
	emit_signal("dead")
