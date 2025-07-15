extends Node3D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _input(event: InputEvent) -> void:
	if event:
		get_tree().change_scene_to_file("res://SimpleRecorder.tscn")
