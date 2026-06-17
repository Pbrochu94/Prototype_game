extends Node
@onready var currentScene = get_tree().current_scene

var rewardBank = [
	{"type": Enum.RewardType.LIGHT_SHARD, "chance": 50},
	{"type": Enum.RewardType.ITEM, "chance": 50},
#	{"type": Enum.RewardType.SPELL, "chance": 15},
#	{"type": Enum.RewardType.SUMMON, "chance": 10}
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
			var key = ItemDB.consumables.keys().pick_random()
			var item = ItemDB.consumables[key]
			RunManager.addItemToInventory(item)
			print("You received: ", item.itemName)
func generateLightAmount():
	var lightShardsGained = currentScene.combatEncounterData.lightShardReward
	RunManager.currentLightShards += lightShardsGained
	print("You gain: ", lightShardsGained, " light shards")
func close():
	rewardsReceived.clear()
