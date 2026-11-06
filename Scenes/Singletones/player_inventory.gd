extends CanvasLayer

func _ready() -> void:
	_updateCoins()
	_updateGems()

func GetCountCoins() -> int:
	return PlayerData.Load("Inventory", "Coins", 0)

func RemoveCoins(count : int) -> void:
	var c = GetCountCoins()
	PlayerData.Save("Inventory", "Coins", c - count)
	_updateCoins()

func AddCoins(count : int) -> void:
	var c = GetCountCoins()
	PlayerData.Save("Inventory", "Coins", c + count)
	_updateCoins()

func GetCountGems() -> int:
	return PlayerData.Load("Inventory", "Gems", 0)

func RemoveGems(count : int) -> void:
	var c = GetCountGems()
	PlayerData.Save("Inventory", "Gems", c - count)
	_updateGems()

func AddGems(count : int) -> void:
	var c = GetCountCoins()
	PlayerData.Save("Inventory", "Gems", c + count)
	_updateGems()

func _updateCoins() -> void:
	var c = GetCountCoins()
	var letter = ""
	var num : int = c
	
	if (c >= 1000):
		letter = "K"
		num = int(c / 1000)
	if (c >= 1000000):
		letter = "M"
		num = int(c / 1000000)
	
	$Coins/Label.text_auto_shrink = str(num) + " " + letter

func _updateGems() -> void:
	var c = GetCountGems()
	var letter = ""
	var num : int = c
	
	if (c >= 1000):
		letter = "K"
		num = int(c / 1000)
	if (c >= 1000000):
		letter = "M"
		num = int(c / 1000000)
	
	$Gems/Label.text_auto_shrink = str(num) + " " + letter
