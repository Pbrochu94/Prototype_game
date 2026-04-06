extends Node


var currentTurn = "player"
var currentCombatScene 
var player 
var enemy 
var playerAnchor
var enemyAnchor

func _ready():
	#Wait for all _ready() to complete
	await get_tree().process_frame
	enemyAnchor = currentCombatScene.enemyAnchor
	player = currentCombatScene.player
	enemy = currentCombatScene.enemy
	playIntro()
	startCombat()

func playIntro():
	if player and enemy:
#		player.walkTarget = playerAnchor.global_position
#		enemy.walkTarget = enemyAnchor.global_position
		player.playIntroWalk(currentCombatScene.playerStartingPosition)
	else:
		print("ERROR: COMBAT SCENE COULD NOT GET PLAYER< ENEMY OR TURN MANAGER")

func startCombat():
	startPlayerTurn()

func startPlayerTurn():
	currentTurn = "player"
	player.chooseAction()

func selectTarget():
	pass

func end_player_turn():
	start_enemy_turn()

func start_enemy_turn():
	currentTurn = "enemy"
	enemy.start_turn()

func end_enemy_turn():
	startPlayerTurn()

