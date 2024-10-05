extends Control
@onready var bgm = $AudioStreamPlayer

func _ready():
	bgm.play()
	
	
func _on_audio_stream_player_finished():
	bgm.play()
