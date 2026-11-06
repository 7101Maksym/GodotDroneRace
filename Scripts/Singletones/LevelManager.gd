extends Node

const COEF_COINS : float = 1
const COEF_GEMS : float = 10

const G_SPEED_DRONE : float = 0.5

func UpgradeDrone(nameOfDrone : String) -> void:
	PlayerData.Save("DronesLevels", nameOfDrone, PlayerData.Load("DronesLevels", nameOfDrone, 1) + 1)

func GetDroneLevel(nameOfDrone : String) -> int:
	return PlayerData.Load("DronesLevels", nameOfDrone, 1)

func GetNeededCoinsForDrone(level : int) -> int:
	return ceil((10 * pow((G_SPEED_DRONE + 1), level)) / COEF_COINS)

func GetNeededGemsForDrone(level : int) -> int:
	return ceil((10 * pow((G_SPEED_DRONE + 1), level)) / COEF_GEMS)
