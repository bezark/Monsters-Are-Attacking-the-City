extends Control

var option1 : String
var option2 : String
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Globals.newscast.prompts.size() <= 2:
		Globals.newscast.prompts = Globals.all_prompts
		Globals.newscast.prompts.shuffle()
		Globals.save()
	option1 = Globals.newscast.prompts.pop_front()
	option2 = Globals.newscast.prompts.pop_front()
	%Option1.text = option1
	%Option2.text = option2




func _on_option_1_button_up() -> void:
	var new_chiron := Clip.new()
	new_chiron.type = "chiron"
	new_chiron.text = option1
	Globals.newscast.prompts.push_front(option2)
	Globals.newscast.clips.append(new_chiron)
	Globals.save()
	get_tree().change_scene_to_file("res://Cameras/Recorder.tscn")


func _on_option_2_button_up() -> void:
	var new_chiron := Clip.new()
	new_chiron.type = "chiron"
	new_chiron.text = option1
	Globals.newscast.prompts.push_front(option2)
	Globals.newscast.clips.append(new_chiron)
	Globals.save()
	get_tree().change_scene_to_file("res://Cameras/Recorder.tscn")


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://BreakingNews/breakingnews.tscn")
