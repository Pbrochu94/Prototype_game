extends Node
#NODES & TRACKING
var currentNode:int
var currentEncounterData:EncounterData = preload("res://utils/Data/EncounterData/Combat/Tutorial/CombatLV0Res.tres")
#var currentEncounterData:EncounterData
#PROGRESS TRACKING
var currentParty:Array[UnitDefinition] 
var currentLightShards:int
var currentXp:int
#STARTING KIT
var startingUnit:UnitDefinition = UnitDB.firstWorldUnits["samurai"].duplicate(true)
const startingLightShards:int = 0
var summoner:SummonerDef

#STATS
var learnedSpells:Dictionary
var allSpells:Dictionary = {
	"fire ball":{
		"res":preload("res://Summoner/Spells/FireBall/FireBallRes.tres"),
		"card scene": preload("res://Summoner/Spells/FireBall/FireBallCardScene.tscn")
	} ,
	"shield":{
		"res":preload("res://Summoner/Spells/Shield/ShieldRes.tres"),
		"card scene": preload("res://Summoner/Spells/Shield/ShieldCardScene.tscn")
	} ,
}
var nmbOfSpellChoice:int = 2
var spellSlot:int = 2

func _ready():
	initNewPlayer()
	initStartingParty()
#	for i in range(5):
#		addUnitToParty(UnitDB.firstWorldUnits.values().pick_random())

func changeScene(scenePath:String):
	get_tree().change_scene_to_file(scenePath)
func createSummonerInstance():
	summoner.sceneInstance = summoner.scene.instantiate()

func initNewPlayer():
	summoner = preload("res://Summoner/SummonerDefRes.tres").duplicate(true)
	createSummonerInstance()

var nodes = [
	{
		"id": 0,
		"type": Enum.EncounterType.COMBAT,
		"completed": false,
		"unlocked": true,
		"encounter data": preload("res://utils/Data/EncounterData/Combat/Tutorial/CombatLV0Res.tres")
	},
	{
		"id": 1,
		"type": Enum.EncounterType.SPELL,
		"completed": false,
		"unlocked": false,
		"encounter data": preload("res://utils/Data/EncounterData/SpellSelection/BasicSpellEncounter/BasicSpellEncounterRes.tres")
#		"encounter data": preload("res://utils/Data/EncounterData/Combat/LV1/CombatEncounterLV1Data.tres")
	},
	{
		"id": 2,
		"type": Enum.EncounterType.COMBAT,
		"completed": false,
		"unlocked": false,
		"encounter data": preload("res://utils/Data/EncounterData/Combat/LV2/CombatEncounterLV2DataRes.tres")
	},
	{
		"id": 3,
		"type": Enum.EncounterType.COMBAT,
		"completed": false,
		"unlocked": false,
		"encounter data": preload("res://utils/Data/EncounterData/Combat/LV2/CombatEncounterLV2DataRes.tres")
	},
	{
		"id": 4,
		"type": Enum.EncounterType.BOSS,
		"completed": false,
		"unlocked": false,
		"encounter data": preload("res://utils/Data/EncounterData/Combat/MiniBoss/MiniBossEncounter.tres")
	}
]

func initStartingParty():
	for i in range(3):
		currentParty.append(UnitDB.firstWorldUnits["blaster droid"].duplicate(true))
#	currentParty.append(startingUnit)

func addUnitToParty(unit:UnitDefinition):
	var unitData = unit.duplicate(true)
	currentParty.append(unitData)

func runReset():
	currentParty.clear()
	resetMapProgress()
	initStartingParty()

func resetMapProgress():
	for node in nodes:
		if node["id"] != 0:
			node["completed"] = false
			node["unlocked"] = false

func removeDownedAllyFromParty():
	for unit in currentParty:
		if unit.sceneInstance.isDead:
			currentParty.erase(unit) 

func summon(unit:UnitDefinition):
	var hasEnoughLightShards:bool = calculateSummonCost(unit.summonCost)
	if hasEnoughLightShards:
		if currentParty.size() >= 5:
			print("party is currently full: ", currentParty)
			return
		var lightShardsBeforePayment = currentLightShards 
		currentLightShards -= unit.summonCost
		var unitNameTag = unit.characterTag
		var summon = UnitDB.firstWorldUnits.get(unitNameTag)
		addUnitToParty(summon)
		print("Player current lightshards : ", lightShardsBeforePayment," -> ", currentLightShards)
	else:
		print(unit.summonCost, " light shards is needed to invoke, player only has: ", currentLightShards)

func calculateSummonCost(unitCost:int):
	if currentLightShards >= unitCost:
		return true
	else:
		return false

func getPlayerInfo():
	var playerInfo: Dictionary = {
		"light shards": RunManager.currentLightShards,
		"xp": RunManager.currentXp
	}
	return playerInfo

func addNewSpell(spellTag:String):
	var newSpell = allSpells[spellTag]["res"]
	print("learning ", spellTag)
	RunManager.learnedSpells[spellTag] = newSpell
	print("Spell inventory: ",RunManager.learnedSpells)

func unlockNextNode():
	RunManager.nodes[RunManager.currentNode]["completed"] = true
	var nextNode = RunManager.currentNode + 1
	if nextNode < RunManager.nodes.size():
		RunManager.nodes[nextNode]["unlocked"] = true
		get_tree().change_scene_to_file("res://MapNodes/OverworldMap/OverworldMap.tscn")
