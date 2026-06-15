extends BaseNonCombatEncounter
@onready var frontTile = $Environments/FrontTile
@onready var frontLights = $Environments/FrontLights
@onready var healCrystal = $Environments/Crystal


func startSceneAnim():
	healCrystal.play("active")

func summonerIntroCompleted():
	super()
	summoner.anim.play("casting")
	await summoner.anim.animation_finished
	healParty()
	summoner.setState("walkout")

func healParty():
	print("heal party")
	for unit in RunManager.currentParty:
		var hpBeforeHeal = unit.currentHp
		unit.currentHp = unit.maxHp
		print(unit.characterName, " was healed from: ", hpBeforeHeal, " -> ", unit.currentHp)
		print(unit.getInfo())

