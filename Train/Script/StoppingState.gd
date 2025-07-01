class_name StoppingState extends TrainState

var _name = "Stopping State"
var max_speed: float = 200.0;

func Enter():
	print("Train Stopping")
	return;


func Process(delta) -> TrainState:
	train.target_speed = 0;
	var distance = train.position.x  - train.stop_position_x
	var smoothing = 0.0
	if distance <= 250 && train.current_speed <= 0:
		print("Stopping area reached!")
		return train.state_machine.get_node("HaltedState")
	
	 #Deceleration factor increases as you get closer
	var decel_strength = clamp((1.0 - (distance / 1000.0)), 0.01013, 0.038)

	smoothing = delta * decel_strength * 0.8
	#print(distance, "\t", train.current_speed, "\t", decel_strength)

	train.current_speed = move_toward(train.current_speed, 0, smoothing * max_speed)
	train.position.x -= train.current_speed * delta
	var rounded_speed = int(train.current_speed / 90) * 90
	if rounded_speed < train.last_speed_marker:
		train.last_speed_marker = rounded_speed
		if not train.whistle.playing:
				#print("Whisle Played!")
			train.whistle.play()
	return null
