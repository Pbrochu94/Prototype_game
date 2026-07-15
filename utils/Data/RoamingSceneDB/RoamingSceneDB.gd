extends Node

var scene = {
	Enum.Section.CAVE : {
		Enum.Area.HUB : preload("res://WorldAreas/Tutorial/Cemetary/WakingUp.tscn")
	}
}

var sceneInstance = {}

func createMapInstance(section:Enum.Section, area:Enum.Area):
	if !sceneInstance.has(section):
		sceneInstance[section] = {}
		sceneInstance[section][area] = scene[section][area].instantiate()
		

