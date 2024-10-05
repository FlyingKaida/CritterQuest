extends Area2D

var speed = 200
var dir = 1
var timer = 0
var max_timer = 2

func _physics_process(delta):
	position += (Vector2.RIGHT * speed * delta * dir)
	$Sprite2D.flip_h = dir
	timer += delta
	if timer >= max_timer:
		queue_free()

func _on_body_entered(body):
	if body.name != "Main":
		print(str(body)+" entered web projectile area")
		#body.queue_free()
		queue_free()
