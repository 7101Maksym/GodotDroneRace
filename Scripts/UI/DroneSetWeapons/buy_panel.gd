extends Control

@onready var buy_type : TextureRect = $Buy/TextureRect
@onready var buy_cost : Label = $Buy/Label
@onready var buy_button : TextureButton = $Buy

enum _cost_in{
	Coins,
	Gems
}

var _current_type_cost : _cost_in
var _current_cost : int
var _current_drone : int

func UpdatePanel(idx_drone : int) -> void:
	var res = load("res://Resources/DroneData/" + str(idx_drone) + ".tres")
	_current_cost = res.cost
	_current_drone = idx_drone
	
	if (res.cost_in == "Coins"):
		_update_button_coins(res.cost)
	elif (res.cost_in == "Gems"):
		_update_button_gems(res.cost)
	elif (res.cost_in == "Special"):
		buy_type.texture = load("res://Images/UI/Lock.png")
		buy_cost.text_auto_shrink = "Special"
		buy_button.disabled = true
		return

func _update_button_coins(cost) -> void:
	buy_type.texture = load("res://Images/UI/Copper Coin.png")
	buy_cost.text_auto_shrink = str(cost)
	
	if PlayerInventory.GetCountCoins() < cost:
		buy_button.disabled = true
	else:
		buy_button.disabled = false
	
	_current_type_cost = _cost_in.Coins

func _update_button_gems(cost) -> void:
	buy_type.texture = load("res://Images/UI/AtlasResources/Gem.tres")
	buy_cost.text_auto_shrink = str(cost)
	
	if PlayerInventory.GetCountGems() < cost:
		buy_button.disabled = true
	else:
		buy_button.disabled = false
	
	_current_type_cost = _cost_in.Gems

func _on_buy_pressed() -> void:
	if (_current_type_cost == _cost_in.Coins):
		PlayerInventory.RemoveCoins(_current_cost)
	elif (_current_type_cost == _cost_in.Gems):
		PlayerInventory.RemoveGems(_current_cost)
	
	PlayerData.Save("Purcases_drones", str(_current_drone), true)
