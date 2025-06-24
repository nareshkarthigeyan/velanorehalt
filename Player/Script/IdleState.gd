class_name IdleState
extends State

func Enter():
	print("In Idle State!")
	player.velocity.x = move_toward(player.velocity.x, 0, player.WALK_SPEED)
	player.AnimatedPlayerSprite.play("idle")

func Physics(delta: float) -> State:
	#print("Inside Idle Physics")
	if not player.is_on_floor():
		return player.state_machine.get_node("JumpState")
	#print("Player on floor!")
	player.velocity.x = 0
	var direction = Input.get_axis("ui_left", "ui_right")
	#print(direction)
	var current_time = Time.get_ticks_msec() / 1000.0
	var input_pressed = ""

	if Input.is_action_just_pressed("ui_left"):
		input_pressed = "ui_left"
	elif Input.is_action_just_pressed("ui_right"):
		input_pressed = "ui_right"
	elif Input.is_action_just_pressed("ui_accept"):
		return player.state_machine.get_node("JumpState")

	if input_pressed != "":
		if current_time - player.last_input_time[input_pressed] <= player.DOUBLE_TAP_TIME:
			if input_pressed == "ui_right":
				player.run_direction = 1
			else:
				player.run_direction = -1
			return player.state_machine.get_node("RunState")
		else:
			player.run_direction = 0

		player.last_input_time[input_pressed] = current_time

	if direction != 0:
		return player.state_machine.get_node("WalkState")

	return null

func HandleInput(event: InputEvent) -> State:
	if event is InputEventScreenTouch:
		if event.pressed:
			player.handle_touch(event.position)	
	return null
