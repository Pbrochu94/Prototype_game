extends Node
var currentScene
var summoner:SummonerDef
const dialogueScene = preload("res://UI/Dialogue/DialogueBox.tscn")
var dialogueBoxInstance:Dialoguebox
var currentDialogue:DialogueRes

func init():
	summoner = RunManager.summoner
func startDialogue(dialogueRes:DialogueRes):
	currentDialogue = dialogueRes
	currentScene = get_tree().current_scene
	dialogueBoxInstance = dialogueScene.instantiate()
	currentScene.add_child(dialogueBoxInstance)
	if currentScene is BaseRoamingScene:
		summoner.roamingSceneInstance.setState(summoner.roamingSceneInstance.State.DIALOGUE)
	dialogueBoxInstance.start(dialogueRes)

func readLine():
	dialogueBoxInstance.textBox.text = currentDialogue.line[0]
	await get_tree().create_timer(5.0).timeout
	endDialogue()
func nextLine():
	pass

func endDialogue():
	if currentScene is BaseRoamingScene:
		summoner.roamingSceneInstance.setState(summoner.roamingSceneInstance.State.IDLE)
