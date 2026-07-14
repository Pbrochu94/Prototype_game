extends Node
var currentScene
const dialogueScene = preload("res://UI/Dialogue/DialogueBox.tscn")
var dialogueBoxInstance:Dialoguebox

func startDialogue(dialogueRes:DialogueRes):
	currentScene = get_tree().current_scene
	dialogueBoxInstance = dialogueScene.instantiate()
	currentScene.add_child(dialogueBoxInstance)
	dialogueBoxInstance.start(dialogueRes)

func nextLine():
	pass

func endDialogue():
	pass
