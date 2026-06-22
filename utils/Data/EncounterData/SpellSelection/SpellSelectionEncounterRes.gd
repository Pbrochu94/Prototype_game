extends EncounterData
class_name SpellSelectionEncounterRes

@export var nmbOfChoices:int 
@export var spellOffered:Array[SummonerSpell]
@export var baseScene:PackedScene
@export var encounterData:EncounterData
var sceneInstance
#func _ready():
##	sceneInstance = scene.instantiate()


