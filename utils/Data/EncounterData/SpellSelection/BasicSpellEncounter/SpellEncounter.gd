extends Node2D

@onready var summoner:BaseSummonerScript = preload("res://Summoner/SummonerCombatScene.tscn").instantiate()
@onready var summonerAnchor = $SummonerAnchor
@onready var summonerIntroStartingPoint = $SummonerIntroStart

# Called when the node enters the scene tree for the first time.
func _ready():
	initSummoner() 

func initSummoner():
	summoner.walkSpeed = 80
	add_child(summoner)
	summoner.global_position = summonerIntroStartingPoint.global_position
	summoner.startingPosition = summonerAnchor.global_position
	summoner.playIntro()
