extends Node2D



func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.coins+=1
		$coin.play()
		$".".visible=false
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		await get_tree().create_timer(1).timeout
		queue_free()


