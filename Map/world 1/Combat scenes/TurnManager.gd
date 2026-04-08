extends Node

@onready var combatMenu = get_tree().get_first_node_in_group("combat menu")
var currentTurn = "player"
var currentCombatScene:Node2D 
var player:Node2D 
var enemy:Node2D 
var enemyAnchor:Node2D

func _ready():
	#Wait for all _ready() to complete
	await get_tree().process_frame
	enemyAnchor = currentCombatScene.enemyAnchor
	player = currentCombatScene.player
	enemy = currentCombatScene.enemy
	player.introFinished.connect(startCombat)
	combatMenu.actionSelected.connect(onActionSelected)
	playIntro()

func playIntro():
	if player and enemy:
		player.playIntroWalk(currentCombatScene.playerStartingPosition)
		enemy.playIntroWalk(currentCombatScene.enemyStartingPosition)
	else:
		print("ERROR: COMBAT SCENE COULD NOT GET PLAYER< ENEMY OR TURN MANAGER")

func startCombat():
	startPlayerTurn()

func startPlayerTurn():
	currentTurn = "player"
	chooseAction()

func chooseAction():
	currentCombatScene.combatMenu.visible = true
	print("Player is choosing...")

func selectTarget():
	pass

func end_player_turn():
	start_enemy_turn()

func start_enemy_turn():
	currentTurn = "enemy"
	enemy.start_turn()

func end_enemy_turn():
	startPlayerTurn()

func onActionSelected(action:String):
	print("Action reçue:", action)

	match action:
		"attack":
			pass
#			player.attack(enemy)
		"inventory":
			pass
		"ability":
			pass
