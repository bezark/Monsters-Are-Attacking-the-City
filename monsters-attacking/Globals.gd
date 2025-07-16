extends Node

@export var newscast: Newscast


func _ready() -> void:
	newscast = ResourceLoader.load("res://newscast.tres")


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		save()
		get_tree().quit()


func save():
	ResourceSaver.save(newscast, "res://newscast.tres")
