class_name HaltedState extends TrainState

var _name = "Halted State"
var max_speed: float = 200.0;

func Enter():
	print("Train Halted")
	train.target_speed = 0
	train.wait_timer = train.stop_duration
	train.has_played_pre_leave_sound = false
	
	await _wait_and_leave()
	return;
	
func _wait_and_leave() -> void:
	print("🕒 Waiting at station for", train.stop_duration, "seconds")

	# Wait for pre-leave whistle
	var pre_leave_time = max(0.0, train.stop_duration - 5.0)
	await get_tree().create_timer(pre_leave_time).timeout

	if not train.has_played_pre_leave_sound:
		train.has_played_pre_leave_sound = true
		train.whistle.play()
		print("🚨 Pre-leave whistle")

	# Wait remaining time
	await get_tree().create_timer(5.0).timeout

	print("🚦 Done waiting, leaving now!")
	train.state_machine.ChangeState(train.state_machine.get_node("LeavingState"))


func Process(delta) -> TrainState:
	#print("Train Wait Timer: ", train.wait_timer)
#
	#await get_tree().create_timer(train.stop_duration - 5).timeout
	##WHy is this played so before?
	#print(train.wait_timer);
	#train.has_played_pre_leave_sound = true
	#train.whistle.play()
	#print("Pre-leave whistle!")
#
	#await get_tree().create_timer(5).timeout
	#return train.state_machine.get_node("LeavingState")
	return null
