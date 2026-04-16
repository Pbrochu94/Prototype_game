extends Node

@export var initialState:State

var currentState:State
var states:Dictionary = {}

func init(owner):
	for child in get_children():
		if child is State:
			print(child.name.to_lower())
			states[child.name.to_lower()] = child
			child.owner = get_parent()
			child.ChangingState.connect(setState)
			
	if initialState:
		initialState.enter()
		currentState = initialState

func _process(delta):
	pass

func _physics_process(delta):
	pass

func setState(state:State):
	if state == currentState:
		return
	if !State:
		return
	if currentState:
		currentState.exit()
	state.enter()
	currentState = state
