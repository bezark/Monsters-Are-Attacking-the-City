extends Control
var ffmpeg_pid: int = -1
var recording_path: String = "res://recording.ogv"


@onready var video: VideoStreamPlayer = $CenterContainer/VBoxContainer/Video




func start_recording():
	var output_path = ProjectSettings.globalize_path(recording_path)
	
	var args = [
		"-device", "/dev/dri/card1",
		"-f", "kmsgrab",
		"-i", "-",
		"-f", "alsa",
		"-i", "hw:3,0",
		"-vf", "hwdownload,format=bgr0",  # No format specified - let ffmpeg choose
		"-c:v", "libtheora",
		"-q:v", "7",
		"-c:a", "libvorbis",
		"-q:a", "4",
		output_path
	]
	# No more sudo needed!
	ffmpeg_pid = OS.create_process("ffmpeg", args)
	print("Started recording with PID: ", ffmpeg_pid)

func stop_recording():
	if ffmpeg_pid != -1:
		OS.execute("kill", ["-INT", str(ffmpeg_pid)])
		
		await get_tree().create_timer(1.0).timeout
		
		ffmpeg_pid = -1
		print("Recording stopped")

func _exit_tree():
	# Clean up if still recording
	if ffmpeg_pid != -1:
		stop_recording()

func _on_button_button_up() -> void:
	pass
	#OS.kill(rec_pid, 2)
	#OS.execute("ffmpeg", ["-i", "temp.mp4", "-c:v", libtheora -q:v 9 -c:a libvorbis -q:a 6 output.ogv])


func _on_record_toggled(toggled_on: bool) -> void:
	if toggled_on:
		start_recording()
	else:
		stop_recording()
		
func play_video():
	$CenterContainer/VBoxContainer/WebcamTexture.hide()
	video.stream.file=recording_path
	video.show()
	video.play()


func _on_video_finished() -> void:
	video.hide()
	$CenterContainer/VBoxContainer/WebcamTexture.show()
	
