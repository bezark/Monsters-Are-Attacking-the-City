extends Node3D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func begin_newscast():
	$Intro.show()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	$Intro/AnimationPlayer.play("intro")


func _input(event: InputEvent) -> void:
	if event:
		$Intro/AnimationPlayer.play("intro")


var clips_played = 0


func play_news():
	$Intro.hide()
	clips_played = 0
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
	pass  # Replace with function body.
