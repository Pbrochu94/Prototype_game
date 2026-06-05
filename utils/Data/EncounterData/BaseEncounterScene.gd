extends Node2D
class_name BaseNonCombatEncounter


@onready var summonerAnchor = $SummonerAnchor
@onready var summonerIntroStartingPoint = $SummonerIntroStart



# Called when the node enters the scene tree for the first time.
func _ready():
	initSummoner() 
	startSceneAnim()
	connectSignals()

func initSummoner():
	RunManager.summoner.walkSpeed = 80
	RunManager.summoner.sceneInstance.z_index = 1
	add_child(RunManager.summoner.sceneInstance)
	RunManager.summoner.sceneInstance.global_position = summonerIntroStartingPoint.global_position
	RunManager.summoner.sceneInstance.startingPosition = summonerAnchor.global_position
	RunManager.summoner.sceneInstance.playIntro()
	RunManager.summoner.sceneInstance.currentScene = self
	print(RunManager.summoner.sceneInstance.currentScene)

func startSceneAnim():
	pass
#	knightThrone.play("active")
#	torchLeft.play("active")
#	torchRight.play("active")

func summonerExit():
	RunManager.summoner.walkSpeed = RunManager.summoner.baseWalkSpeed
	RunManager.summoner.z_index = 1

func connectSignals():
	RunManager.summoner.sceneInstance.introAnimCompleted.connect(summonerIntroCompleted)

func summonerIntroCompleted():
	print("intro done")
