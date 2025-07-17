extends MarginContainer


@export var text : String:
	set(val):
		text= val
		$VBoxContainer/Footer/Body/Label.text = text
