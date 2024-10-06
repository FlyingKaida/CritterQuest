extends Node2D



func _on_area_2d_body_entered(body):
	print(body)
	if body.is_in_group("player"):
		print('is in group')
		if body.stats.hp<body.stats.maxhp:
			body.stats.hp+=1
			queue_free()


