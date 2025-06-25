extends Node2D
class_name Train

@export var max_speed: float = 200.0
@export var stop_duration: float = 45.0

var current_speed: float = 0.0
var target_speed: float = 0.0
#var state: String = "idle"
var wait_timer: float = 45.0
var stop_position_x: float = 0.0

@onready var whistle = $Sprite2D/WhistleSound
@onready var coach_sound = $Coach_Sound
@onready var state_machine = $TrainStateMachine

var last_speed_marker := 99999
var has_played_pre_leave_sound := false

func train_cycle(station_position: Vector2):
	position = Vector2(position.x, station_position.y - 45)  # Behind station
	stop_position_x = station_position.x
	#state = "running"  # NEW: Start in running before approaching
	state_machine.Initialize(self)
	current_speed = max_speed
	target_speed = max_speed

func _process(delta):
	# match state:
	# 	"running":
	# 		target_speed = max_speed
	# 		# Enter "approaching" once station is within range
	# 		var distance = position.x - stop_position_x
	# 		if distance <= 12000:  # adjust threshold as needed
	# 			state = "approaching"

	# 	"approaching":
	# 		target_speed = max_speed
	# 		var distance = position.x - stop_position_x
	# 		if distance <= 7000:
	# 			state = "stopping"

	# 	"stopping":
	# 		target_speed = 0.0
	# 		var distance = position.x - stop_position_x
	# 		if abs(current_speed) <= 100.0 or distance <= 50:
	# 			state = "halt"

	# 	"halt":
	# 		target_speed = 0.0
	# 		if abs(current_speed) <= 1.0:
	# 			state = "waiting"
	# 			wait_timer = stop_duration
	# 			has_played_pre_leave_sound = false
	# 			last_speed_marker = 99999  # reset

	# 	"waiting":
	# 		target_speed = 0.0
	# 		wait_timer -= delta

	# 		if wait_timer <= 5.0 and not has_played_pre_leave_sound:
	# 			has_played_pre_leave_sound = true
	# 			whistle.play()
	# 			print("Whisle Played!")

	# 		if wait_timer <= 0.0:
	# 			state = "leaving"

	# 	"leaving":
	# 		target_speed = max_speed
	# 		if position.x < -10500:
	# 			queue_free()

	# # Movement smoothing based on state
	# var smoothing: float = 0.0
	# match state:
	# 	"stopping":
	# 		smoothing = delta * 0.01
	# 	"halt":
	# 		smoothing = delta * 0.3
	# 	"leaving", "running", "approaching":
	# 		smoothing = delta * 0.5
	# 	_:
	# 		smoothing = delta * 0.04

	# current_speed = move_toward(current_speed, target_speed, smoothing * max_speed)
	# position.x -= current_speed * delta
	#print("In Train process")
	#print(current_speed);
	state_machine._process(delta);

	# Sync coach sound and pitch
	for coach in get_children():
		if coach.has_node("Coach_Sound"):
			var coach_sound = coach.get_node("Coach_Sound")
			coach_sound.pitch_scale = clamp(abs(current_speed) / max_speed, 0.5, 1.5)
			if abs(current_speed) > 2.0:
				if not coach_sound.playing:
					coach_sound.play()
			else:
				if coach_sound.playing:
					coach_sound.stop()

	# Whistle sound as train slows
	#TODO: ADD THIS IN HALT STATE AND STOPPING STATE
	#if state == "stopping":
		#var rounded_speed = int(current_speed / 75) * 75
		#if rounded_speed < last_speed_marker:
			#last_speed_marker = rounded_speed
			#if not whistle.playing:
				#print("Whisle Played!")
				#whistle.play()
