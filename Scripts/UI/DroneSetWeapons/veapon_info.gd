extends NinePatchRect

@onready var name_gun : Label = $InformContainer/Name
@onready var icon : TextureRect = $InformContainer/Icon
@onready var damage : Label = $InformContainer/Damage/Value
@onready var reload : Label = $InformContainer/ReloadSpeed/Value
@onready var mass : Label = $InformContainer/Mass/Label
@onready var buy_button : TextureButton = $BuyWeapon

var _current_gun_name : String

signal weapon_has_bought

func SetDescription(name_of_weapon : String, current_position : Vector2):
	#regex needed only for finding weapon
	var expr : RegEx = RegEx.new()
	expr.compile("#.+")
	name_of_weapon = expr.sub(name_of_weapon, "")
	
	if (name_of_weapon != "Empty"):
		if (!PlayerData.Load("My weapons", name_of_weapon, false)):
			$DeleteWeapon.hide()
			buy_button.show()
		else:
			$DeleteWeapon.show()
			buy_button.hide()
		
		_current_gun_name = name_of_weapon
		
		var res = load("res://Resources/WeaponsData/" + name_of_weapon + ".tres")
		name_gun.text = tr(res.name)
		icon.texture = res.icon
		damage.text_auto_shrink = str(res.damage)
		reload.text_auto_shrink = str(res.reloadTime) + " s"
		mass.text_auto_shrink = str(res.weight)
		
		_set_cost_of_weapon()
	else:
		name_gun.text_auto_shrink = tr("EMPTY_NAME")
		icon.texture = null
		damage.text_auto_shrink = "--"
		reload.text_auto_shrink = "--"
		mass.text_auto_shrink = "--"
	
	_set_line(current_position)
	
	if (current_position == Vector2.ZERO):
		$DeleteWeapon.hide()
	else:
		$DeleteWeapon.show()
	
	$AnimationPlayer.play("Open")

func _set_cost_of_weapon() -> void:
	var res : WeaponData = load("res://Resources/WeaponsData/" + _current_gun_name + ".tres")
	
	if (res.cost_in == 3):
		$BuyWeapon/Lock.show()
		$BuyWeapon/Label.hide()
		$BuyWeapon/TextureRect.hide()
		buy_button.disabled = true
	else:
		$BuyWeapon/Lock.hide()
		$BuyWeapon/Label.show()
		$BuyWeapon/TextureRect.show()
		buy_button.disabled = false
	
	if (res.cost_in == 0):
		$BuyWeapon/TextureRect.texture = preload("res://Images/UI/AtlasResources/Gem.tres")
		if (PlayerInventory.GetCountGems() < res.cost):
			buy_button.disabled = true
		else:
			buy_button.disabled = false
	elif (res.cost_in == 1):
		$BuyWeapon/TextureRect.texture = preload("res://Images/UI/Copper Coin.png")
		if (PlayerInventory.GetCountCoins() < res.cost):
			buy_button.disabled = true
		else:
			buy_button.disabled = false
	
	$BuyWeapon/Label.text_auto_shrink = str(res.cost)

func _set_line(p2 : Vector2) -> void:
	if (p2 == Vector2.ZERO):
		$Line2D.hide()
		$Sprite2D.hide()
		return
	else:
		$Line2D.show()
		$Sprite2D.show()
	
	var p1 = Vector2i($InformContainer.size.x / 2, 41)
	
	var res : PackedVector2Array = [p1, $Line2D.to_local(p2)]
	$Line2D.points = res
	$Sprite2D.position = $Line2D.to_local(p2)

func _on_buy_weapon_pressed() -> void:
	var res : WeaponData = load("res://Resources/WeaponsData/" + _current_gun_name + ".tres")
	
	if (res.cost_in == 0):
		PlayerInventory.RemoveGems(res.cost)
	elif (res.cost_in == 1):
		PlayerInventory.RemoveCoins(res.cost)
	
	PlayerData.Save("My weapons", _current_gun_name, true)
	SetDescription(_current_gun_name, Vector2.ZERO)
	emit_signal("weapon_has_bought")
