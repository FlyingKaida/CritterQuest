extends Area2D



func _on_body_entered(body):
	if body.is_in_group("player"):
		get_tree().get_root().get_node("Main").setScores('lost', body.coins, 13, 0,  body.levelTimer, body.slainCount)
		get_tree().get_root().get_node("Main").end()
	if body.is_in_group("monster"):
		queue_free()
	pass # Replace with function body.


func _on_body_exited(body):
	if body.is_in_group("player"):
		get_tree().get_root().get_node("Main").setScores('lost', body.coins, 13, 0,  body.levelTimer, body.slainCount)
		get_tree().get_root().get_node("Main").end()
	if body.is_in_group("monster"):
		queue_free()
	pass # Replace with function body.
