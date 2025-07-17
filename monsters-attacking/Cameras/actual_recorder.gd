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
	new_clip.vid = full_video_path
	Globals.newscast.clips.append(new_clip)
	Globals.save()
	get_tree().change_scene_to_file("res://BreakingNews/breakingnews.tscn")
