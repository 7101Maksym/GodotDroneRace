extends Node

func GetCardCount(nameOfDrone : String) -> int:
	return PlayerData.Load("Cards", nameOfDrone, 0)

func AddCards(count : int, nameOfDrone : String) -> void:
	PlayerData.Save("Cards", nameOfDrone, count + GetCardCount(nameOfDrone))

func SpendCards(count : int, nameOfDrone : String) -> void:
	PlayerData.Save("Cards", nameOfDrone, GetCardCount(nameOfDrone) - count)
