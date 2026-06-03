extends Node2D


@onready var summonerAnchor = $SummonerAnchor
@onready var summonerIntroStartingPoint = $SummonerIntroStart
@onready var torchLeft = $bk/TorchLeft
@onready var torchRight = $bk/TorchRight
@onready var  knightThrone = $bk/Knight


# Called when the node enters the scene tree for the first time.
func _ready():
	initSummoner() 
	startSceneAnim()

func initSummoner():
	RunManager.summoner.walkSpeed = 80
	RunManager.summoner.z_index = 1
	add_child(RunManager.summoner)
	RunManager.summoner.global_position = summonerIntroStartingPoint.global_position
	RunManager.summoner.startingPosition = summonerAnchor.global_position
	RunManager.summoner.playIntro()

func startSceneAnim():
	knightThrone.play("active")
	torchLeft.play("active")
	torchRight.play("active")

func summonerExit():
	RunManager.summoner.walkSpeed = 80
	RunManager.summoner.z_index = 1
