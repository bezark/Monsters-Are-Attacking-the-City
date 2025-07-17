extends Node

@export var newscast: Newscast
@export var all_prompts : Array[String]
var counter = 0
var should_play = false

func _ready() -> void:
	newscast = ResourceLoader.load("res://Videos/newscast.tres")


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		save()
		get_tree().quit()
		
	if Input.is_action_just_pressed("ui_down"):
		counter += 1
		if counter >= 10:
			var videos = DirAccess.open('res://Videos')
			for clip in newscast.clips:
				if clip.vid:
					videos.remove(str(clip.vid))
			
			newscast.clips = []
			newscast.prompts = all_prompts
			save()
			counter = 0
			$Debug.show()
			await get_tree().create_timer(2.0).timeout
			$Debug.hide()

	


func save():
	ResourceSaver.save(newscast, "res://Videos/newscast.tres")
