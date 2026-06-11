extends Node


const firstWorldUnits : Dictionary = {
	"samurai": preload("res://Invocations/Samurai/SamuraiDefinition.tres"),
	"archer": preload("res://Invocations/Archer/ArcherDefinition.tres"),
	"blaster droid":preload("res://Invocations/BlasterDruid/BlasterDroidDef.tres"),
	"cannon droid": preload("res://Invocations/CannonDruid/CannonDroidDef.tres")
}
const firstWorldMiniBosses:Dictionary =  {
	"lord of flames": preload("res://Invocations/LordOfFlames/LordOfFlamesDef.tres")
}


func createUnitInstance(characterTag:String):
	var unit = UnitInstance.new()
	unit.definition = UnitDB.firstWorldUnits[characterTag]
	unit.characterName = unit.definition.characterName
	unit.characterTag = unit.definition.characterTag
	unit.currentHp = unit.definition.maxHp
	unit.atk = unit.definition.baseAtk
	unit.deff = unit.definition.baseDeff
	unit.speed = unit.definition.speed
	return unit
