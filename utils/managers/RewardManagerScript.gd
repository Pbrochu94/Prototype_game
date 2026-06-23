extends Node
@onready var currentScene = get_tree().current_scene

var rewardBank = [
	{"type": Enum.RewardType.LIGHT_SHARD, "chance": 50},
	{"type": Enum.RewardType.ITEM, "chance": 5},
#	{"type": Enum.RewardType.SPELL, "chance": 15},
#	{"type": Enum.RewardType.SUMMON, "chance": 10}
]
var consumableChance = [
	{"name": Enum.RewardType.ITEM, "chance": 50},
]
var rewardsReceived:Array

func grantReward():
	var rewardType = selectRewardType()
	rewardsReceived.append(selectRewardItem(rewardType))
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
func selectRewardItem(type:Enum.RewardType):
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
	var lightShardsGained = currentScene.encounterData.lightShardReward
	RunManager.currentLightShards += lightShardsGained
	print("You gain: ", lightShardsGained, " light shards")
func close():
	rewardsReceived.clear()
