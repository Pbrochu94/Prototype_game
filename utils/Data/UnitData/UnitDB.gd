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
	unit.atk = unit.definition.atk
	unit.deff = unit.definition.deff
	unit.speed = unit.definition.speed
	unit.maxHp =  unit.definition.maxHp
	unit.baseSpeed =  unit.definition.speed
	unit.baseDeff =  unit.definition.deff
	unit.baseAtk =  unit.definition.atk
	return unit
