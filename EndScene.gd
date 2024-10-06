extends Node2D


var cause
var coins = 0
var maxCoins = 0
var hearts = 0
var time = 0
var score = 0
var slain = 0

func _ready():
	$AnimationPlayer2.play('sleep')

func _process(delta):
	if cause == 'lost':
		$GameOver.visible = true
	if cause == 'win':
		$Congratulations.visible = true
	
	score = (coins * 10) + (100 - time)/2 + (slain * 20)
	if cause == "lost":
		score = 0
	
	$coinLabel.text = str(coins) + " / " + str(maxCoins)
	$clockLabel.text = str(int(time)) + " Seconds"
	$scoreLabel.text = "Score " + str(int(score))
	$killedLabel.text = str(slain)
	
# continue button
func _on_button_pressed():
	get_tree().get_root().get_node("Main").mapChange("ship")
	pass # Replace with function body.
