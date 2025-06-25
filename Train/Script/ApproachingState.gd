class_name ApproachingState extends TrainState

var _name = "Approaching State"
var max_speed: float = 200.0;

func Enter():
	print("Train Approaching")
	return;

func Process(delta) -> TrainState:
	train.target_speed = max_speed * 0.8;
	var distance = train.position.x  - train.stop_position_x
	if distance <= 7000:
		return train.state_machine.get_node("StoppingState")
	
	var smoothing = delta * 0.5
	train.current_speed = move_toward(train.current_speed, train.target_speed, smoothing * max_speed)
	train.position.x -= train.current_speed * delta
	print(train.current_speed)
	return null
