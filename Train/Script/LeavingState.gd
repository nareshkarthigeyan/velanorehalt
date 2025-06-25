class_name LeavingState extends TrainState

var _name = "Leaving State"
var max_speed: float = 200.0;

func Enter():
	print("Train Leaving")
	return;

func Process(delta) -> TrainState:
	train.target_speed = max_speed;
	var smoothing;
	if train.current_speed < 50:
		smoothing = delta * 0.01
	else:
		smoothing = delta * 0.1
	train.current_speed = move_toward(train.current_speed, 500, smoothing * max_speed)
	train.position.x -= train.current_speed * delta
	print(train.current_speed)
	return null
