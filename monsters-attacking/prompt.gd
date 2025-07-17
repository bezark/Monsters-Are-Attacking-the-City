extends Control
signal prompt_finished


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func reveal():
	show()
	$Timer.start()


func _on_commercial_button_down() -> void:
	var commercials = Clip.new()
	commercials.type = "commercial"
	Globals.newscast.clips.append(commercials)
	# print(Globals.newscast.clips)
	Globals.save()
	finish_prompt()


func finish_prompt():
	hide()
	prompt_finished.emit()


func _on_more_news_button_up() -> void:
	$Initial.hide()
	get_tree().change_scene_to_file("res://Cameras/Recorder.tscn")


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://BreakingNews/breakingnews.tscn")
