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
	'speed': 50,
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
		#velocity.y = -1 * _delta
	
	if stats.hp > 0:
		
		
		#if Input.is_action_just_pressed("space"):
			#if is_attacking == false:
				#is_attacking=true
				#print('attacking')
				#atk_timer =1
				#$sprites/slash.visible=true
				#$attack.play()
			#action_timer=0
			#pass


				
			
		if velocity.y >= 200:
			velocity.y = 200
		
		if action_timer <= 0:
			dir = randi_range(-1,1)
			action_timer = 5
		
		if is_on_wall_only():
			dir = randi_range(-1,1)
			action_timer = 5
			
		#if dir != 0:
		rev_sprite(dir)
		velocity.x = dir  * stats.speed 
		
	move_and_slide()
	#update_animations(direction)
	
func rev_sprite(dir):
	$WolfSprite.flip_h = (dir == -1)

#func hide_anims():
	#$sprites/IdleCatt.visible=false
	#$sprites/Idle2Catt.visible=false
	#$sprites/AttackCatt.visible=false
	#$sprites/Die.visible=false
	#$sprites/DieCatt.visible=false
	#$sprites/HurtCattt.visible=false
	#$sprites/JumpCattt.visible=false
	#$sprites/RunCatt.visible=false
	#$sprites/Sittingg.visible=false
	#$sprites/SleepCatt.visible=false
	#$sprites/slash.visible=false
	

func get_anim(_delta):
	
	if is_on_floor():
		is_jumping = false
	if atk_timer <= 0:
		is_attacking = false
	
	if stats.hp <= 0:
		if options.gore == 1:
			$AnimationPlayer.play("die_noblood")
		else:
			$AnimationPlayer.play("die")
	
	elif hit_timer > 0:
		#$AnimationPlayer.play("hurt")
		hit_timer-=_delta
		
	elif is_attacking:
		$AnimationPlayer.play("attack")
		atk_timer-=_delta
		
	elif djump == true:
		$AnimationPlayer.play("djump")
	
	elif is_jumping == true:
		$AnimationPlayer.play("jump")
		
	elif velocity != Vector2.ZERO:
		$AnimationPlayer.play("run")
	
	elif action_timer > 20:
		$AnimationPlayer.play("sleep")
	elif action_timer > 10:
		$AnimationPlayer.play("sitting")
	elif action_timer > 5:
		$AnimationPlayer.play("idle2")
		
		
	else:
		$sprites/IdleCatt.visible=true
		$AnimationPlayer.play("idle")


func _physics_process(_delta):
	action_timer-= _delta
	#hide_anims()
	get_input(_delta)
	#get_anim(_delta)
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
		$WolfSprite.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		$WolfSprite.modulate = Color.WHITE
		await get_tree().create_timer(0.1).timeout
	
	
func _on_area_2d_body_entered(body):
	if body.name != "Wolf" and body.name != "foreground-tilemap":
		body.hit(stats.atk, $".".position)
