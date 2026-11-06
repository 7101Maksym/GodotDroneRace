extends Control

@onready var _upgradeData : Label = $Upgrade/Label
@onready var _upgradeButton : TextureButton = $Upgrade
@onready var _upgradeImage : TextureRect = $UpgradeCost/Image
@onready var _upgradeCost : Label = $UpgradeCost/UpgData
@onready var _upgradeByGemsButton : TextureButton = $UpgradeCost/UpgradeByGems

var _currentDrone : Drone = null
var _neededCoins : int
var _neededGems : int

signal DroneUpgrated

func SetCurrentDrone(drone : Drone) -> void:
	_currentDrone = drone
	
	_setUpgData()

func _setUpgData() -> void:
	if (_currentDrone.Level >= 30):
		_upgradeData.text_auto_shrink = "MAX"
		_setUpgBtnDisabled()
		_upgradeByGemsButton.disabled = true
		_upgradeByGemsButton.hide()
		return
	
	var cards = CardManager.GetCardCount(str(_currentDrone.nameOfDrone))
	
	_neededCoins = LevelManager.GetNeededCoinsForDrone(_currentDrone.Level)
	_neededGems = LevelManager.GetNeededGemsForDrone(_currentDrone.Level)
	
	if (cards >= int(remap(_currentDrone.Level, 1, 29, 10, 5000))):
		_upgradeData.text_auto_shrink = tr("UPGRADE")
		_setUpgBtnEnabled()
		_setCoinsCount()
	else:
		_upgradeData.text_auto_shrink = str(cards) + "/" + str(int(remap(_currentDrone.Level, 1, 29, 10, 5000)))
		_setUpgBtnDisabled()
		_setGemsCount()

func _setUpgBtnDisabled() -> void:
	_upgradeButton.disabled = true

func _setUpgBtnEnabled() -> void:
	_upgradeButton.disabled = false

func _setCoinsCount() -> void:
	_upgradeImage.texture = load("res://Images/UI/Copper Coin.png")
	_upgradeCost.text_auto_shrink = str(_neededCoins)
	_upgradeByGemsButton.disabled = true
	_upgradeByGemsButton.hide()
	
	if (_neededCoins > PlayerInventory.GetCountCoins()):
		_setUpgBtnDisabled()

func _setGemsCount() -> void:
	_upgradeImage.texture = load("res://Images/UI/AtlasResources/Gem.tres")
	_upgradeCost.text_auto_shrink = str(_neededGems)
	_upgradeByGemsButton.disabled = false
	_upgradeByGemsButton.show()
	
	if (_neededGems > PlayerInventory.GetCountGems()):
		_upgradeByGemsButton.disabled = true

func _upgradeByCoins() -> void:
	PlayerInventory.RemoveCoins(_neededCoins)
	CardManager.SpendCards(int(remap(_currentDrone.Level, 1, 29, 10, 5000)), str(_currentDrone.nameOfDrone))
	_currentDrone.LevelUp()
	emit_signal("DroneUpgrated")
	_setUpgData()

func _upgradeByGems() -> void:
	PlayerInventory.RemoveGems(_neededGems)
	_currentDrone.LevelUp()
	emit_signal("DroneUpgrated")
	_setUpgData()
