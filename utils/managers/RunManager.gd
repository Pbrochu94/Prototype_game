extends Node
#NODES & TRACKING
var currentNodeId:int
var currentEncounterData:EncounterData = preload("res://utils/Data/EncounterData/Combat/LV2/CombatEncounterLV2DataRes.tres").duplicate(true)
var currentParty:Array[UnitInstance] 
var currentLightShards:int
var currentXp:int
const startingLightShards:int = 0
var summoner:SummonerDef
var inventory:Dictionary
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

#FIRST BOOT ----------------------------------------------------------------------------------------
func _ready():
	initNewPlayer()
	initStartingParty()
func initNewPlayer():
	summoner = preload("res://Summoner/SummonerDefRes.tres").duplicate(true)
	createSummonerInstance()
#	for i in range(3):
#		addItemToInventory(ItemDB.consumables["light potion"])
func createSummonerInstance():
	summoner.sceneInstance = summoner.scene.instantiate()
#INVENTORY MANAGEMENT ------------------------------------------------------------------------------
func addItemToInventory(item:ItemData):
	if item.itemName not in inventory:
		inventory[item.itemName] = item
	elif inventory[item.itemName].stack >= inventory[item.itemName].maxStack:
		print("Max amount of ",inventory[item.itemName].itemName," reached")
		return
	inventory[item.itemName].stack += 1
#PARTY MANAGING ------------------------------------------------------------------------------------
func initStartingParty():
#	for i in range(3):
#		currentParty.append(UnitDB.createUnitInstance("cannon droid"))
	currentParty.append(UnitDB.createUnitInstance("lord of flames"))
func addUnitToParty(unit:UnitInstance):
	var unitData = unit.duplicate(true)
	currentParty.append(unitData)
func removeDownedAllyFromParty():
	for unit in currentParty:
		if unit.sceneInstance.isDead:
			currentParty.erase(unit) 

#RUN RESET -----------------------------------------------------------------------------------------
func gameOver():
	runReset()
	changeScene("res://MapNodes/OverworldMap/OverworldMap.tscn")
func runReset():
	resetParty()
	resetMapProgress()
	resetSummonerPerks()
	initStartingParty()
func resetSummonerPerks():
	learnedSpells.clear()
func resetParty():
	currentParty.clear()
func resetMapProgress():
	for node in nodes:
		if node["id"] != 0:
			node["completed"] = false
			node["unlocked"] = false
		else:
			node["completed"] = false
			node["unlocked"] = true

#SUMMON AND INVOKING -------------------------------------------------------------------------------
func summon(unit:UnitInstance):
	var unitCost = unit.definition.summonCost
	var hasEnoughLightShards:bool = calculateSummonCost(unitCost)
	if hasEnoughLightShards:
		if currentParty.size() >= 5:
			print("party is currently full: ", currentParty)
			return
		var lightShardsBeforePayment = currentLightShards 
		currentLightShards -= unitCost
		var unitNameTag = unit.characterTag
		var summon = UnitDB.createUnitInstance(unitNameTag)
		addUnitToParty(summon)
		print("Player current lightshards : ", lightShardsBeforePayment," -> ", currentLightShards)
	else:
		print(unit.definition.summonCost, " light shards is needed to invoke, player only has: ", currentLightShards)
func calculateSummonCost(unitCost:int):
	if currentLightShards >= unitCost:
		return true
	else:
		return false

#SUMMONER MANAGING ---------------------------------------------------------------------------------
func getPlayerInfo():
	var playerInfo: Dictionary = {
		"light shards": RunManager.currentLightShards,
		"xp": RunManager.currentXp
	}
	if not inventory.is_empty():
		playerInfo["inventory"] = []
		for itemName in inventory:
			var inventorySummary = {
				"name": itemName,
				"amount": inventory[itemName]["amount"]
			}
			playerInfo["inventory"].append(inventorySummary)
	return playerInfo
func addNewSpell(spellTag:String):
	var newSpell = allSpells[spellTag]["res"]
	print("learning ", spellTag)
	RunManager.learnedSpells[spellTag] = newSpell
	print("Spell inventory: ",RunManager.learnedSpells)
#NODE PROGRESSION ----------------------------------------------------------------------------------
var nodes = [
	{
		"id": 0,
		"next":[1],
		"same level nodes":[],
		"type": Enum.EncounterType.COMBAT,
		"completed": false,
		"unlocked": true,
		"encounter data": preload("res://utils/Data/EncounterData/Combat/Tutorial/CombatLV0Res.tres")
	},
	{
		"id": 1,
		"next":[2,3],
		"same level nodes":[],
		"type": Enum.EncounterType.COMBAT,
		"completed": false,
		"unlocked": false,
		"encounter data": preload("res://utils/Data/EncounterData/Combat/LV1/CombatEncounterLV1Data.tres")
	},
	{
		"id": 2,
		"next":[4],
		"same level nodes":[3],
		"type": Enum.EncounterType.SPELL,
		"completed": false,
		"unlocked": false,
		"encounter data": preload("res://utils/Data/EncounterData/SpellSelection/BasicSpellEncounter/BasicSpellEncounterRes.tres")
	},
	{
		"id": 3,
		"next":[4],
		"same level nodes":[2],
		"type": Enum.EncounterType.COMBAT,
		"completed": false,
		"unlocked": false,
		"encounter data": preload("res://utils/Data/EncounterData/Combat/LV2/CombatEncounterLV2DataRes.tres")
	},
	{
		"id": 4,
		"next":[5],
		"same level nodes":[],
		"type": Enum.EncounterType.COMBAT,
		"completed": false,
		"unlocked": false,
		"encounter data": preload("res://utils/Data/EncounterData/Combat/LV2/CombatEncounterLV2DataRes.tres")
	},
	{
		"id": 5,
		"next":[6],
		"same level nodes":[],
		"type": Enum.EncounterType.HEAL,
		"completed": false,
		"unlocked": false,
		"encounter data": preload("res://utils/Data/EncounterData/HealEncounter/HealEncounterRes.gd")
	},
	{
		"id": 6,
		"next":[],
		"same level nodes":[],
		"type": Enum.EncounterType.BOSS,
		"completed": false,
		"unlocked": false,
		"encounter data": preload("res://utils/Data/EncounterData/Combat/MiniBoss/MiniBossEncounter.tres")
	}
]
#func unlockNextNode():
#	RunManager.nodes[RunManager.currentNode]["completed"] = true
#	var sameLevelNodes:Array =  RunManager.nodes[RunManager.currentNode]["same level nodes"]
#	for nodeId in sameLevelNodes:
#		RunManager.nodes[nodeId]["completed"] = true
#	var nextNodes = RunManager.nodes[currentNode]["next"]
#	for nodeId in nextNodes:
#		RunManager.nodes[nodeId]["unlocked"] = true
#	get_tree().change_scene_to_file("res://MapNodes/OverworldMap/OverworldMap.tscn")
func changeScene(scenePath:String):
	get_tree().change_scene_to_file(scenePath)
