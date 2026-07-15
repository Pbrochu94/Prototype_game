extends Node
var currentScene
var summoner:SummonerDef
const dialogueScene = preload("res://UI/Dialogue/DialogueBox.tscn")
var dialogueBoxInstance:Dialoguebox
var currentDialogue:DialogueRes
var currentLineIndex:int = 0

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
	dialogueBoxInstance.textBox.text = currentDialogue.line[currentLineIndex]
	await get_tree().create_timer(2.0).timeout
	nextLine()
func nextLine():
	if currentLineIndex == currentDialogue.line.size() - 1:
		endDialogue()
		return
	currentLineIndex += 1
	readLine()

func endDialogue():
	closeDialogueBox()
	currentLineIndex = 0
	if currentScene is BaseRoamingScene:
		summoner.roamingSceneInstance.setState(summoner.roamingSceneInstance.State.IDLE)

func closeDialogueBox():
	dialogueBoxInstance.queue_free()
