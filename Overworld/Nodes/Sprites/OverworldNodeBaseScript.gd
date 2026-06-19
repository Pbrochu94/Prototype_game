extends Node
class_name OverworldNode
@onready var anim = $AnimatedSprite2D

func onHover():
	print("hover")
	anim.scale = Vector2(1.2, 1.2)



func onMouseExit():
	print("unhover")
	anim.scale = Vector2(1, 1)



func onClick(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		print("clicked")
