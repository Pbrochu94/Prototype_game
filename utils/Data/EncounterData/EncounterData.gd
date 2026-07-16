extends Resource
class_name EncounterData


@export var encounterType: Enum.EncounterType
@export var overworldNodeScene:PackedScene
@export var id:int
@export var nextEncounters:Array[EncounterData]
@export var previousEncounters:Array[EncounterData]
@export var completed:bool = false
@export var unlocked:bool = false
@export var baseScene:PackedScene
@export var sceneInstance:CombatEncounter
@export var encounterData:EncounterData
@export var level:Enum.EncounterLevel
@export var LightShardChance:int
@export var itemChance:int
@export var introDialogue:DialogueRes
@export var endingDialogue:DialogueRes
@export var isScripted:bool
@export var scriptedUnits:Array[UnitDefinition]
