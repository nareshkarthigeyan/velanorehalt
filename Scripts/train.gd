extends Node2D
class_name Train

@export var max_speed: float = 200.0
@export var stop_duration: float = 20.0

var current_speed: float = 0.0
var target_speed: float = 0.0
var state: String = "idle"
var wait_timer: float = 25.0
var stop_position_x: float = 0.0

@onready var whistle = $Sprite2D/WhistleSound
@onready var coach_sound = $Coach_Sound

var last_speed_marker := 99999
var has_played_pre_leave_sound := false

func train_cycle(station_position: Vector2):
	position = Vector2(position.x, station_position.y - 45)  # Behind station
	stop_position_x = station_position.x
	state = "approaching"
	current_speed = 200
	target_speed = max_speed

func _process(delta):
	#print(current_speed)
	match state:
		"approaching":
			target_speed = max_speed
			var distance = position.x - stop_position_x
			if distance <= 7000:
				state = "stopping"

		"stopping":
			target_speed = 0.0
			var distance = position.x - stop_position_x
			if abs(current_speed) <= 100.0 || distance <= 50:
				state = "halt"
				#wait_timer = stop_duration
				#has_played_pre_leave_sound = false
				#last_speed_marker = 99999  # reset
		
		"halt":
			target_speed = 0.0
			if abs(current_speed) <= 1.0:
				state = "waiting"
				wait_timer = stop_duration
				has_played_pre_leave_sound = false
				last_speed_marker = 99999  # reset

		"waiting":
			target_speed = 0.0
			wait_timer -= delta

			# Play sound 3 seconds before leaving
			if wait_timer <= 5.0 and not has_played_pre_leave_sound:
				has_played_pre_leave_sound = true
				whistle.play()
				print("Whisle Played!")

			if wait_timer <= 0.0:
				state = "leaving"

		"leaving":
			target_speed = max_speed
			if position.x < -10500:
				queue_free()

	var smoothing: float = 0.0
	match state:
		"stopping":
			smoothing = delta * 0.01
		"halt":
			smoothing = delta * 0.3
		"leaving":
			smoothing = delta * 0.04
		_:
			smoothing = delta * 0.5

	current_speed = move_toward(current_speed, target_speed, smoothing * max_speed)
	position.x -= current_speed * delta

# Called every frame inside _process(delta)
	for coach in get_children():
		if coach.has_node("Coach_Sound"):
			var coach_sound = coach.get_node("Coach_Sound")
			# Pitch sync
			coach_sound.pitch_scale = clamp(abs(current_speed) / max_speed, 0.5, 1.5)
			# Play or stop sound
			if abs(current_speed) > 2.0:
			#if not coach_sound.playing:
				if not coach_sound.playing:
					coach_sound.play()
			else:
				if coach_sound.playing:
					#coach_sound.pitch_scale = clamp(abs(current_speed) / max_speed, 0.05, 1.5)
					coach_sound.stop()

	# Play whistle every time speed drops across a multiple of 75
	if state == "stopping":
		#print(current_speed)
		var rounded_speed = int(current_speed / 75) * 75
		if rounded_speed < last_speed_marker:
			last_speed_marker = rounded_speed
			if not whistle.playing:
				print("Whisle Played!")
				whistle.play()
