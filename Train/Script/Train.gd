extends Node2D
class_name Train

@export var max_speed: float = 200.0
@export var stop_duration: float = 60.0

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
