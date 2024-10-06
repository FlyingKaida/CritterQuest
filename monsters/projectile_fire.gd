extends Node2D


var speed = 200
var dir = 1
var timer = 0
var max_timer = 2

func _physics_process(delta):
	position += (Vector2.RIGHT * speed * delta * dir)
	$Area2D/Sprite2D.flip_h = (dir == -1)
	timer += delta
	if timer >= max_timer:
		queue_free()




func _on_area_2d_body_entered(body):
	pass # Replace with function body.
	if body.name != "Main":
		body.hit(1, $".".position, "fire")
		queue_free()
		
