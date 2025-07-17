extends Control
var ffmpeg_pid: int = -1
var base_path: String = "res://Videos/"
var current_video : String
var full_video_path: String 

var countdown = 3
var recording = false
var state = 'preview'
@onready var video: VideoStreamPlayer = %Video




func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		match state:
			'preview':
				$Instructions.hide()
				$Countdown.show()
				$Countdown/Timer.start()
				$Whoosh.play()
				Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
			'recording':
				stop_recording()
				



			

func start_recording():
	
	state = "recording"
	var output_path = ProjectSettings.globalize_path(base_path)
	current_video = Time.get_datetime_string_from_system()
	full_video_path = str(output_path,current_video)
	print(full_video_path)
	var args
	var system = OS.get_distribution_name()
	print(system)
	if system == "cpe:/o:nixos:nixos:25.11":
		args = [
			"-f", "pulse",
			"-i", "default",
			"-f", "lavfi", 
			"-i", "color=c=black:s=720x480:r=30",
			"-c:v", "libtheora",
			"-q:v", "10",
			"-c:a", "libvorbis",
			"-q:a", "5",
			"-shortest",
			str(full_video_path, ".ogv")
		]
	else:
		args = [
		"-v", "verbose",
		
		# Important: Set format flags BEFORE inputs
		"-f", "alsa",
		"-thread_queue_size", "1024",
		"-buffer_size", "2048",
		"-ar", "44100",
		"-ac", "1",
		"-i", "hw:CARD=PureAudio,DEV=0",
		
		"-f", "x11grab",
		"-framerate", "30",  # Use -framerate instead of -r for input
		"-video_size", "720x480",
		"-thread_queue_size", "1024",  # Also for video
		"-i", ":0.0",
		
		# Critical sync and real-time options
		"-use_wallclock_as_timestamps", "1",
		"-async", "1",
		"-vsync", "cfr",  # Constant frame rate
		"-copyts",  # Copy timestamps
		"-start_at_zero",  # Start timestamps at zero
		
		# Encoding options with constraints
		"-c:v", "libtheora",
		"-b:v", "2000k",  # Set video bitrate
		"-q:v", "7",  # Lower quality value = higher quality
		"-c:a", "libvorbis", 
		"-b:a", "128k",  # Set audio bitrate
		"-ar", "44100",  # Ensure output sample rate
		
		# Output options
		"-shortest",  # Stop when shortest stream ends
		"-avoid_negative_ts", "make_zero",
		full_video_path + ".ogv"
	]
	
	ffmpeg_pid = OS.create_process("ffmpeg", args)
	recording = true
	print("Started recording with PID: ", ffmpeg_pid)

func stop_recording():
	if ffmpeg_pid != -1 and recording:
		recording = false
		
		# Method 1: Use SIGINT (Ctrl+C) - allows FFmpeg to finalize properly
		OS.execute("kill", ["-INT", str(ffmpeg_pid)])
		
		# Give FFmpeg more time to flush buffers and finalize the file
		var wait_time = 0.0
		var max_wait = 5.0
		
		while OS.is_process_running(ffmpeg_pid) and wait_time < max_wait:
			await get_tree().create_timer(0.1).timeout
			wait_time += 0.1
		
		# If still running after grace period, force kill
		if OS.is_process_running(ffmpeg_pid):
			print("FFmpeg didn't stop gracefully, force killing...")
			OS.execute("kill", ["-KILL", str(ffmpeg_pid)])
			await get_tree().create_timer(0.5).timeout
		
		ffmpeg_pid = -1
		print("Recording stopped after ", wait_time, " seconds")
		
		# Add small delay before playing to ensure file is fully written
		await get_tree().create_timer(0.5).timeout
		play_video()
		
#func stop_recording():
	#if ffmpeg_pid != -1:
		#OS.execute("kill", ["-INT", str(ffmpeg_pid)])
		#
		#await get_tree().create_timer(1.0).timeout
		#
		##ffmpeg_pid = -1
		##OS.execute("ffmpeg" ,[
			##"-i", str(full_video_path,".mkv"),  "-c:v", "libtheora", "-q:v", "6", "-c:a", "libvorbis", "-q:a", "3", str(full_video_path,".ogv")
		##]
		##)
		#print("Recording stopped")
		#play_video()

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
	state = "playback"
	print("trying to play video...")
	$WebcamTexture.hide()
	video.stream = VideoStreamTheora.new()
	video.stream.file=str(full_video_path,".ogv")
	video.show()
	video.play()


func _on_video_finished() -> void:
	$CenterContainer/Buttons.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_timer_timeout() -> void:
	countdown -= 1
	if countdown >=1:
		$Countdown.text = str(countdown)
		$Whoosh.play()
	else:
		$Countdown/Timer.stop()
		$Countdown.hide()
		start_recording()
	


func _on_redo_button_up() -> void:
	var videos = DirAccess.open('res://Videos')
	videos.remove(str(current_video,'.ogv'))
	countdown = 3
	$CenterContainer/Buttons.hide()
	$WebcamTexture.show()
	video.hide()
	$Countdown.show()
	$Countdown/Timer.start()
	$Whoosh.play()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN



func _on_submit_pressed() -> void:
	print('submitting')
	var new_clip:= Clip.new()
	new_clip.vid = str(full_video_path, ".ogv")
	Globals.newscast.clips.append(new_clip)
	Globals.save()
	get_tree().change_scene_to_file("res://BreakingNews/breakingnews.tscn")
