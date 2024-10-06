extends Area2D



func _on_body_entered(body):
	if body.is_in_group("player"):
		$CPUParticles2D.emitting = true
		$win.play()
		await get_tree().create_timer(2).timeout
		get_tree().get_root().get_node("Main").setScores('won', body.coins, 13, 0,  body.levelTimer, body.slainCount)
		get_tree().get_root().get_node("Main").end()

