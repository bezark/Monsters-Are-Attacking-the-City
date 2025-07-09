extends Control
var recorder :MovieWriter= MovieWriter.new()
#func _ready() -> void:
	#add_writer(recorder)
func _on_button_button_down() -> void:
	recorder._write_begin(Vector2i(1280,720), 30, "res://testvid.ogv")



func _on_button_button_up() -> void:
	recorder._write_end()
