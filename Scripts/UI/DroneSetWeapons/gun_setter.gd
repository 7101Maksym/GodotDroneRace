extends Control

signal set_weapon(weapon_name)

var _myWeaponName : String = ""

func SetMyWeapon(v_name : String):
	_myWeaponName = v_name
	CheckWeapon()

func CheckWeapon() -> void:
	var expr : RegEx = RegEx.new()
	expr.compile("#.+")
	if (PlayerData.Load("My weapons", expr.sub(_myWeaponName, ""), false)):
		$Closed.hide()

func SetIcon(icon) -> void:
	$Button.icon = icon

func _on_button_pressed() -> void:
	emit_signal("set_weapon", _myWeaponName)
