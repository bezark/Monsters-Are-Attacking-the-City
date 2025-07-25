extends Control
var ffmpeg_pid: int = -1
var base_path: String = "res://Videos/"
var current_video : String
var full_video_path: String 


@onready var video: VideoStreamPlayer = %Video


func start_recording():
	var output_path = ProjectSettings.globalize_path(base_path)
	current_video = Time.get_datetime_string_from_system()
	full_video_path = str(output_path,current_video)
	print(full_video_path)
	var args = [
		"-v", "verbose",
		
		# Audio input FIRST (helps with sync)
		"-f", "alsa",
		"-thread_queue_size", "2048",  # Increase buffer
		"-ar", "44100",  # Set sample rate explicitly
		"-ac", "1",  # Mono
		"-i", "hw:CARD=PureAudio,DEV=0",
		
		# Video input SECOND
		"-f", "x11grab", 
		"-r", "30",
		"-video_size", "720x480",  # Use -video_size instead of -s
		"-i", ":0.0",
		
		# Sync and timing options
		"-use_wallclock_as_timestamps", "1",  # Better timestamp handling
		"-async", "1",  # Audio sync
		"-vsync", "1",  # Video sync
		
		# Encoding options
		"-c:v", "libtheora", 
		"-q:v", "10",
		"-c:a", "libvorbis",
		"-q:a", "5",  # Audio quality
		
		# Output
		str(full_video_path, ".ogv")
	]
	
	ffmpeg_pid = OS.create_process("ffmpeg", args)
	print("Started recording with PID: ", ffmpeg_pid)


func stop_recording():
	if ffmpeg_pid != -1:
		OS.execute("kill", ["-INT", str(ffmpeg_pid)])
		
		await get_tree().create_timer(1.0).timeout
		
		#ffmpeg_pid = -1
		#OS.execute("ffmpeg" ,[
			#"-i", str(full_video_path,".mkv"),  "-c:v", "libtheora", "-q:v", "6", "-c:a", "libvorbis", "-q:a", "3", str(full_video_path,".ogv")
		#]
		#)
		print("Recording stopped")
		play_video()

func _exit_tree():
	# Clean up if still recording
	if ffmpeg_pid != -1:
		stop_recording()


func _on_record_toggled(toggled_on: bool) -> void:
	if toggled_on:
		start_recording()
	else:
		stop_recording()
		
		
func play_video():
	print("trying to play video...")
	$CenterContainer/VBoxContainer/WebcamTexture.hide()
	video.stream = VideoStreamTheora.new()
	video.stream.file=str(full_video_path,".ogv")
	video.show()
	video.play()


func _on_video_finished() -> void:
	video.hide()
	$CenterContainer/VBoxContainer/WebcamTexture.show()
	
