extends Node2D

var current_map 
var cause = ""
var coins = 0
var maxCoins = 0
var hearts = 0
var time = 0
var score = 0
var slain = 0

# JSON object holding all maps preloaded
var maps = {
	'mainmenu': preload("res://MainMenu.tscn"),
	'end': preload("res://EndScene.tscn"),
	'ship': preload("res://levels/CatShip.tscn"),
	'W1L1': preload("res://levels/tiles.tscn"),
	'W1L2': preload("res://levels/plainslevel.tscn"),
	'W1B': preload("res://levels/plainslevel-boss.tscn"),
	'W2L1': preload("res://levels/Cloud1.tscn"),
	'W2L2': preload("res://levels/Cloud2.tscn"),
	'W2B': preload("res://levels/Cloud-boss.tscn"),
	#'tiles': preload(),
	#'tiles': preload(),
	#'tiles': preload(),
	#'tiles': preload(),
	#'tiles': preload(),
	#'tiles': preload(),
}

# sets the scores pre endmap
func setScores(tcause, tcoins, tmaxCoins, thearts,  tlevelTimer, tslain):
	cause = tcause
	coins = tcoins
	maxCoins = tmaxCoins
	hearts = thearts
	time = tlevelTimer
	slain = tslain

# end current map and loads endscreen
func end():
	current_map.queue_free()
	#start('end')
	call_deferred("start", 'end')
	
	if cause == 'lost':
		cause='lost'
	else:
		cause='win'
	coins = coins
	maxCoins = maxCoins
	hearts = hearts
	time = time

#starts next map/endscreen
func start(map):
	current_map = maps[map].instantiate()
	$".".add_child(current_map)	
	current_map.position = Vector2(0, 0)
	if map == "end":
		current_map.name = str(map)
		current_map.cause = cause
		current_map.coins = coins
		current_map.maxCoins = maxCoins
		current_map.hearts = hearts
		current_map.time = time
		current_map.slain = slain

#initial start map
func _ready():
	start('W1L1')

func mapChange(map):
	print("Shifting map to " + str(map))
	current_map.queue_free()
	await get_tree().create_timer(1).timeout
	start(map)
