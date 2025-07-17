extends Node

@export var newscast: Newscast
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
			newscast.clips = []
			save()
			counter = 0
			$Debug.show()
			await get_tree().create_timer(2.0).timeout
			$Debug.hide()

	


func save():
	ResourceSaver.save(newscast, "res://Videos/newscast.tres")
