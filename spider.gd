extends CharacterBody2D

@export var id = 0
#var dir = 0
var moving = false
var direction : Vector2 = Vector2.ZERO
var _gravity = 400
var djump = false
var is_jumping = false
var is_attacking = true
var atk_timer = 0
var action_timer = 0
var hit_timer = 0
var dash_timer = 0
var dir = 1

@export var options = {
	'gore': 1,
	'volume': 100,
}

@export var stats = {
	'hp': 10,
	'maxhp': 10,
	'speed': 60,
	'jump_force': 200,
	'atk': 1,
}

@export var upgrades = {
	"djump" : true,
	'dash': true,
	'sprint': true,
	'fire': true,
	'ground_pound': true,
	'break_wall': true,
	'wall_jump': true,
	
}


func _ready():

	pass

func get_input(_delta):
	
	if is_on_floor() == false:
		velocity.y += _gravity * _delta
	else:
		djump = false
	
	if stats.hp > 0:
		
		if velocity.y >= 200:
			velocity.y = 200
		
		if action_timer <= 0:
			dir = randi_range(-1,1)
			action_timer = 5
		
		if is_on_wall_only():
			dir = randi_range(-1,1)
			action_timer = 5
			
		rev_sprite(dir)
		velocity.x = dir  * stats.speed 
		
	move_and_slide()
	
func rev_sprite(dir):
	$sprite.flip_h = (dir == -1)





func _physics_process(_delta):
	action_timer-= _delta
	get_input(_delta)
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	set_velocity(velocity)
	move_and_slide()
	velocity = velocity
	#$Camera2D/Label.text =  "Last acted: " + str(int(action_timer)) +  "\nHit Timer: " + str(int(hit_timer))
	if stats.hp<=0:
		queue_free()


func hit(atk, enemyPos):
	hit_timer=5
	stats.hp-=atk
	velocity = (-enemyPos * .1) 
	for i in range(10):
		$sprite.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		$sprite.modulate = Color.WHITE
		await get_tree().create_timer(0.1).timeout
	
	
func _on_area_2d_body_entered(body):
	print(body)
	if body.name != "spider" and body.name != "foreground-tilemap":
		body.hit(stats.atk, $".".position)
		
