extends VideoStreamPlayer

signal commercial_finished


func play_ads():
	paused = false
	show()
	$Timer.start()


func _on_timer_timeout() -> void:
	hide()
	print('times up')
	paused = true
	commercial_finished.emit()
