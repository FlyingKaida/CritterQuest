extends Node2D


var speed = 200
var dir = 1
var timer = 0
var max_timer = 2

func _physics_process(delta):
	position += (Vector2.RIGHT * speed * delta * dir)
	$Area2D/Sprite2D.flip_v = (dir == 1)
	timer += delta
	if timer >= max_timer:
		queue_free()

#func _on_body_entered(body):
	#
	#if body.name != "Main":
		#print(str(body)+" entered web projectile area")
		##body.queue_free()
		#queue_free()


func _on_area_2d_body_entered(body):
	pass # Replace with function body.
	if body.name != "Main":
		print(str(body)+" entered web projectile area")
		body.hit(0, $".".position, "webbed")
		queue_free()
		
