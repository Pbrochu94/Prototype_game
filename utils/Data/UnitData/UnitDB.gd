extends Node


const firstWorldUnits : Dictionary = {
	"samurai": preload("res://Invocations/Samurai/SamuraiDefinition.tres"),
	"archer": preload("res://Invocations/Archer/ArcherDefinition.tres"),
	"blaster droid":preload("res://Invocations/BlasterDruid/BlasterDroidDef.tres"),
	"cannon droid": preload("res://Invocations/CannonDruid/CannonDroidDef.tres")
}
const firstWorldMiniBosses:Array[UnitDefinition] =  [
	preload("res://Invocations/LordOfFlames/LordOfFlamesDef.tres")
]
