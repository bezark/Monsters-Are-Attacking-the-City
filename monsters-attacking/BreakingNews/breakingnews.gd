extends Node3D
var idling = true

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	if Globals.should_play:
		begin_newscast()


func begin_newscast():
	clips_played = 0
	Globals.should_play = false
	$Intro.show()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	$Commercials.play()
	$Intro/AnimationPlayer.play("intro")


func _input(event: InputEvent) -> void:
	if event is InputEventMouse and idling:
		$Intro/AnimationPlayer.play("intro")
		idling = false


var clips_played = 0


func play_news():
	$Intro.hide()
	
	
	
	if clips_played >= Globals.newscast.clips.size():
		$Prompt.reveal()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	else:
		var clip: Clip = Globals.newscast.clips[clips_played]
		clips_played += 1
		match clip.type:
			"commercial":
				$Commercials.play_ads()
				$News.hide()
			'clip':
				$News.stream.file = clip.vid
				$News.play()
				$News.show()
				$Commercials.hide()


func change():
	get_tree().change_scene_to_file("res://SimpleRecorder.tscn")


func _on_commercials_commercial_finished() -> void:
	play_news()


func _on_prompt_prompt_finished() -> void:
	begin_newscast()


func _on_news_finished() -> void:
	play_news()
