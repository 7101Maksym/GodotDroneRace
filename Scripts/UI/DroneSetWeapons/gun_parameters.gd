extends RichTextLabel

func UpdateParametrs(name_of_gun : String, base_dmg : float, base_recharge : float) -> void:
	var level = GunManager.GetLevel(name_of_gun)
	
	var t = "[img]res://Images/UI/Icons/1 Icons/Red/Skillicon11_23.png[/img]"
	t += remap(level, 1, 30, base_dmg, base_dmg * 2)
	t += "[img]res://Images/UI/Icons/1 Icons/White/Skillicon7_17.png[/img]"
	t += remap(level, 1, 30, base_recharge, base_recharge * 0.5)
	
	text = t
