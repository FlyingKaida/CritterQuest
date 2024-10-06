extends CharacterBody2D

@export var id = 0
#var dir = 0
var moving = false
var dir : Vector2 = Vector2.ZERO
var _gravity = 400
var djump = false
var is_jumping = false
var is_attacking = true
var atk_timer = 0
var action_timer = 0
var hit_timer = 0
var dash_timer = 0
var webbed_timer = 0

@export var options = {
	'gore': 1,
	'volume': 100,
}

@export var stats = {
	'hp': 10,
	'maxhp': 10,
	'speed': 100,
	'jump_force': 200,
	'atk': 5,
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
		
		
		if Input.is_action_just_pressed("space"):
			if is_attacking == false:
				is_attacking=true
				atk_timer =1
				$sprites/slash.visible=true
				$attack.play()
			action_timer=0
			pass

		
		if Input.is_action_just_pressed("ui_up"):
			if ! is_on_wall():
				if is_on_floor():
					if webbed_timer>0:
						velocity.y = -stats.jump_force/1.5
					else:
						velocity.y = -stats.jump_force
						
					is_jumping = true
					action_timer=0
					$jump.play()
				elif ! djump :
					if upgrades.djump == true:
						djump = true
						velocity.y = -stats.jump_force
						is_jumping = true
						action_timer=0
						$jump.play()
				
			
		if velocity.y >= 500:
			velocity.y = 500
		var direction = Input.get_axis("ui_left", "ui_right")
		
		
		if direction != 0:
			action_timer=0
			rev_sprite(direction)
		
		if webbed_timer>0:
			velocity.x = direction  * stats.speed  / 2
		else:
			velocity.x = direction  * stats.speed 
		
	move_and_slide()
	#update_animations(direction)
	
func rev_sprite(direction):
	$sprites/IdleCatt.flip_h = (direction == -1)
	$sprites/Idle2Catt.flip_h = (direction == -1)
	$sprites/AttackCatt.flip_h = (direction == -1)
	$sprites/Die.flip_h = (direction == -1)
	$sprites/DieCatt.flip_h = (direction == -1)
	$sprites/HurtCattt.flip_h = (direction == -1)
	$sprites/JumpCattt.flip_h = (direction == -1)
	$sprites/RunCatt.flip_h = (direction == -1)
	$sprites/Sittingg.flip_h = (direction == -1)
	$sprites/SleepCatt.flip_h = (direction == -1)
	$sprites/slash.flip_h = (direction == -1)
	$sprites/slash.position.x=$sprites/AttackCatt.position.x+20*direction

func hide_anims():
	$sprites/IdleCatt.visible=false
	$sprites/Idle2Catt.visible=false
	$sprites/AttackCatt.visible=false
	$sprites/Die.visible=false
	$sprites/DieCatt.visible=false
	$sprites/HurtCattt.visible=false
	$sprites/JumpCattt.visible=false
	$sprites/RunCatt.visible=false
	$sprites/Sittingg.visible=false
	$sprites/SleepCatt.visible=false
	$sprites/slash.visible=false
	

func get_anim(_delta):
	
	if is_on_floor() and ! is_on_wall():
		is_jumping = false
	if atk_timer <= 0:
		is_attacking = false
		$sprites/slash/Area2D/CollisionShape2D.disabled=true
	if hit_timer > 0:
		#$sprites/HurtCattt.visible=true
		#$AnimationPlayer.play("hurt")
		hit_timer-=_delta
	
	if stats.hp <= 0:
		if options.gore == 1:
			$sprites/DieCatt.visible=true
			$AnimationPlayer.play("die_noblood")
		else:
			$sprites/Die.visible=true
			$AnimationPlayer.play("die")
	#
	#elif hit_timer > 0:
		#$sprites/HurtCattt.visible=true
		#$AnimationPlayer.play("hurt")
		#hit_timer-=_delta
		
	elif is_attacking:
		$sprites/AttackCatt.visible=true
		$sprites/slash.visible=true
		$AnimationPlayer.play("attack")
		atk_timer-=_delta
		$sprites/slash/Area2D/CollisionShape2D.disabled=false
		
	elif djump == true:
		$sprites/JumpCattt.visible=true
		$AnimationPlayer.play("djump")
	
	elif is_jumping == true:
		$sprites/JumpCattt.visible=true
		$AnimationPlayer.play("jump")
		
	elif velocity != Vector2.ZERO:
		$sprites/RunCatt.visible=true
		$AnimationPlayer.play("run")
	
	elif action_timer > 20:
		$sprites/SleepCatt.visible=true
		$AnimationPlayer.play("sleep")
	elif action_timer > 10:
		$sprites/Sittingg.visible=true
		$AnimationPlayer.play("sitting")
	elif action_timer > 5:
		$sprites/Idle2Catt.visible=true
		$AnimationPlayer.play("idle2")
		
		
	else:
		$sprites/IdleCatt.visible=true
		$AnimationPlayer.play("idle")


func hit(atk, enemyPos, status="none"):
	if status == "webbed":
		webbed_timer = 10
		
	hit_timer=2
	stats.hp-=atk
	if atk > 0:
		velocity = (-enemyPos * .20) 
		$tookDmg.play()
	for i in range(10):
		$sprites.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		$sprites.modulate = Color.WHITE
		await get_tree().create_timer(0.1).timeout
	
	

func _physics_process(_delta):
	action_timer+= _delta
	if action_timer>=1000:
		action_timer==1000
		
	webbed_timer-= _delta
	if webbed_timer<=0:
		webbed_timer=0
		
	hide_anims()
	get_input(_delta)
	get_anim(_delta)
	dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	set_velocity(velocity)
	move_and_slide()
	velocity = velocity
	$Camera2D/Label.text =  "HP: " + str(stats.hp) +"/"+str(stats.maxhp) + "\nLast acted: " + str(int(action_timer)) +  "\nHit Timer: " + str(int(hit_timer)) +  "\nVelocity: " + str(velocity)



func _on_area_2d_body_entered(body):
	print(body)
	if  body.name != "foreground-tilemap" and body.name != "foreground-tilemap2":
		body.hit(stats.atk, $".".position)

