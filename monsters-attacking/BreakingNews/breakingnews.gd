extends Node3D

@export var min_chiron = 3
@export var max_chiron = 10

var idling = true

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	if Globals.should_play:
		begin_newscast()


func begin_newscast():
	clips_played = 0
	$News.hide()
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
var time_since_chiron = 0

func play_news():
	$Intro.hide()
	
	
	
	if clips_played >= Globals.newscast.clips.size():
		if time_since_chiron >= randi_range(min_chiron,max_chiron):
			get_tree().change_scene_to_file("res://ChironPrompt.tscn")
			
		$Prompt.reveal()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	else:
		time_since_chiron +=1
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
			'chiron':
				time_since_chiron = 0
				$Intro.show()
				$Intro/Headline.mesh.text = clip.text
				$News/Chiron.text = clip.text
				$News.hide()
				$Commercials.hide()
				$Intro/AnimationPlayer.play("transition")

func change():
	get_tree().change_scene_to_file("res://SimpleRecorder.tscn")


func _on_commercials_commercial_finished() -> void:
	play_news()


func _on_prompt_prompt_finished() -> void:
	begin_newscast()


func _on_news_finished() -> void:
	play_news()
