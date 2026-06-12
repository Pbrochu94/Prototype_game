extends State
class_name HurtState

func _onready():
	pass

func enter():
#	owner.anim.play("hurt")
	hurtFlash()

func update(delta):
	pass

func exit():
	pass


func hurtFlash():
	var mat = owner.anim.material as ShaderMaterial
	mat.set_shader_parameter("flash_amount", 1.0)
	var tween = create_tween()
	tween.tween_method(
		func(value):
			mat.set_shader_parameter("flash_amount", value),1.0,0.0,0.25)
