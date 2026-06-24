extends Node
#NODES & TRACKING
var currentNodeId:int
var currentEncounterData:EncounterData 
var previousEncounter:EncounterData
var currentParty:Array[UnitInstance] 
var currentLightShards:int
var currentXp:int
const startingLightShards:int = 0
var summoner:SummonerDef
var inventory:Dictionary
var currentWorld
var worldEncounters:Array[EncounterData]
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
	initIntroMap()
func initIntroMap():
	currentWorld = WorldsDB.worlds.intro.instantiate()
	for i in range(7):
		if i == 3:
			worldEncounters.append(EncounterDB.createEncounter(Enum.EncounterType.SPELL,Enum.EncounterLevel.TUTORIAL))
		elif i == 5:
			worldEncounters.append(EncounterDB.createEncounter(Enum.EncounterType.HEAL,Enum.EncounterLevel.TUTORIAL))
		elif i == 6:
			worldEncounters.append(EncounterDB.createEncounter(Enum.EncounterType.MINI_BOSS,Enum.EncounterLevel.TUTORIAL))
		else:
			worldEncounters.append(EncounterDB.createEncounter(Enum.EncounterType.COMBAT, Enum.EncounterLevel.TUTORIAL))
	worldEncounters[0].unlocked = true
	linkEncounters()
func linkEncounters():
	var node1 = worldEncounters[0]
	var node2 = worldEncounters[1]
	var node3 = worldEncounters[2]
	var node4 = worldEncounters[3]
	var node5 = worldEncounters[4]
	var node6 = worldEncounters[5]
	var node7 = worldEncounters[6]
	node1.nextEncounters.append(node2)
	node2.previousEncounters.append(node1)
	node2.nextEncounters.append(node3)
	node3.previousEncounters.append(node2)
	node3.nextEncounters.append_array([node4,node5])
	node4.previousEncounters.append(node3)
	node4.nextEncounters.append(node6)
	node5.previousEncounters.append(node3)
	node5.nextEncounters.append(node6)
	node6.previousEncounters.append_array([node4,node5])
	node6.nextEncounters.append(node7)
	node4.unlocked = true
	node5.unlocked = true
	node6.unlocked = true
	node7.unlocked = true
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
	currentWorldEncounters.clear()

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
var currentWorldEncounters:Array[EncounterData]
func unlockNextNode():
	for encounter in currentEncounterData.nextEncounters:
		encounter.unlocked = true
		currentEncounterData.completed = true
	previousEncounter = currentEncounterData
	get_tree().change_scene_to_file("res://Overworld/WorldMaps/Intro/IntroMapScene.tscn")
func changeScene(scenePath:String):
	var path = str(currentWorld.scene_file_path)
	print(path)
	get_tree().change_scene_to_file(path)
