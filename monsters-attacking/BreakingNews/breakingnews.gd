extends Node3D
var idling = true

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func begin_newscast():
	clips_played = 0
	$Intro.show()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	$Commercials.play()
	$Intro/AnimationPlayer.play("intro")


func _input(event: InputEvent) -> void:
	if event and idling:
		$Intro/AnimationPlayer.play("intro")
		idling = false


var clips_played = 0


func play_news():
	$Intro.hide()
	
	print(clips_played)
	if clips_played >= Globals.newscast.clips.size():
		print('showing prompt')
		$Prompt.show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	else:
		var clip: Clip = Globals.newscast.clips[clips_played]
		clips_played += 1
		match clip.type:
			"commercial":
				$Commercials.play_ads()


func change():
	get_tree().change_scene_to_file("res://SimpleRecorder.tscn")


func _on_commercials_commercial_finished() -> void:
	play_news()


func _on_prompt_prompt_finished() -> void:
	begin_newscast()
