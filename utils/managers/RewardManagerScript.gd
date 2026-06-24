extends Node
@onready var currentScene = get_tree().current_scene
var rewardBank 

func init(encounterData):
	rewardBank = [
		{"type": Enum.RewardType.LIGHT_SHARD, "chance": encounterData.LightShardChance},
		{"type": Enum.RewardType.ITEM, "chance": encounterData.itemChance},
	]

var consumableChance = [
	{"name": Enum.RewardType.ITEM, "chance": 50},
]
var rewardsReceived:Array

func grantReward():
	var rewardType = selectRewardType()
	rewardsReceived.append(selectReward(rewardType))
#	for reward in rewardsReceived:
#		RunManager.addItemToInventory(reward)
func selectRewardType():
	var totalWeight = 0
	for reward in rewardBank:
		totalWeight += reward.chance
	var roll = randi_range(1, totalWeight)
	var currentWeight = 0
	for reward in rewardBank:
		currentWeight += reward.chance
		if roll <= currentWeight:
			return reward.type
func selectReward(type:Enum.RewardType):
	match type:
		Enum.RewardType.LIGHT_SHARD:
			generateLightAmount()
		Enum.RewardType.ITEM:
			RunManager.addItemToInventory(randomlySelectConsumable())
func randomlySelectConsumable():
	var totalWeight = 0
	for itemName in ItemDB.consumables:
		totalWeight += ItemDB.consumables[itemName].chance
	var roll = randi_range(1, totalWeight)
	var currentWeight = 0
	for itemName in ItemDB.consumables:
		currentWeight += ItemDB.consumables[itemName].chance
		if roll <= currentWeight:
			print("You got a ",ItemDB.consumables[itemName].res.itemName)
			return ItemDB.consumables[itemName].res
func generateLightAmount():
	var lightShardGainFloor:int = currentScene.encounterData.lightShardReward[0]
	var lightShardGainCeiling:int = currentScene.encounterData.lightShardReward[1]
	var lightShardsGained = randi_range(lightShardGainFloor, lightShardGainCeiling)
	RunManager.currentLightShards += lightShardsGained
	print("You gain: ", lightShardsGained, " light shards")
func close():
	rewardsReceived.clear()
