extends Node2D

##Image, that will be displayed in UI
@export var MyImage : AtlasTexture
@export_group("Bullet settings")
##Left - (-1), right - (1)
@export_range(-1, 1) var _directionX : int
@export var _maxSpeed : float
@export var _minSpeed : float = _maxSpeed
##Maximum vertical scatter in degrees
@export_range(0, 90) var _shellScetter : float
@export var _bullet : PackedScene
@export_group("Shooting settings")
@export var _bulletsPerShoot : int
@export var _bulletDelay : float
##Use, if object must shooting automatically
@export var _shootingTimer : Timer
@export var _reloadTime : float
@export var _reloadTimer : Timer

var _readyToShoot : bool = true
var _myIndicator : ProgressBar

func _ready() -> void:
	_reloadTimer.connect("timeout", Reload)
	
	if (_shootingTimer != null):
		_shootingTimer.timeout.connect(Shoot)

func _process(_delta: float) -> void:
	if (_readyToShoot == false):
		_myIndicator.value = _reloadTimer.time_left

func SetIndicator(indicator : ProgressBar):
	_myIndicator = indicator
	_myIndicator.value = 0
	_myIndicator.max_value = _reloadTime

func Shoot() -> void:
	if (_readyToShoot):
		for i in _bulletsPerShoot:
			get_tree().create_timer(i * _bulletDelay).timeout.connect(GenerateBullet)
		
		_readyToShoot = false
		_reloadTimer.start(_reloadTime)

func GenerateBullet():
	var bullet = _bullet.instantiate()
	bullet.global_position = $GeneratingPoint.global_position
	
	if (bullet is Bullet):
		bullet.BulletDirection = _directionX
		bullet.rotation = deg_to_rad(randf_range(-_shellScetter, _shellScetter))
		bullet.Speed = randf_range(_minSpeed, _maxSpeed)
	
	BulletContainer.get_bullet_container().add_child(bullet)

func Reload():
	_readyToShoot = true
	_myIndicator.value = 0
