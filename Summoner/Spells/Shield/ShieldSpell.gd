extends BaseSpellScript



func onAnimationFinished():
	match anim.animation:
		"appear":
			anim.play("active")
			emit_signal("spellFinishedCasting")
		"disapear":
			queue_free()
