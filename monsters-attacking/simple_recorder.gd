extends Control
var rec_pid
func _on_button_button_down() -> void:
	OS.create_instance([])
	#rec_pid = OS.create_process("wf-recorder",["-c","libx264","-r","30", "--audio","-f","temp.mp4"])
	# Step 1: Record with fast H.264
#wf-recorder -c libx264 -p "crf=18,preset=superfast" -r 30 --audio -f temp.mp4

# Step 2: Convert to high-quality OGV
#ffmpeg -i temp.mp4 -c:v libtheora -q:v 9 -c:a libvorbis -q:a 6 output.ogv

# Remove temp file
#rm temp.mp4



func _on_button_button_up() -> void:
	pass
	#OS.kill(rec_pid, 2)
	#OS.execute("ffmpeg", ["-i", "temp.mp4", "-c:v", libtheora -q:v 9 -c:a libvorbis -q:a 6 output.ogv])
