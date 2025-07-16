extends Control
signal prompt_finished


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_more_news_button_down() -> void:
	pass


func _on_commercial_button_down() -> void:
	var commercials = Clip.new()
	commercials.type = "commercial"
	Globals.newscast.clips.append(commercials)
	# print(Globals.newscast.clips)
	Globals.save()


func finish_prompt():
	hide()
	prompt_finished.emit()
