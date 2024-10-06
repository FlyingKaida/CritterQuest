extends Node2D



func hit(atk, enemyPos, status="none"):
	$".".visible=false
	$"../lever green".visible=true
	$"../../door/StaticBody2D/CollisionShape2D".set_deferred("disabled", true)
	$"../../door/AnimationPlayer".play("open")
