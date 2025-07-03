class_name BoardedState
extends State

func Enter() -> void:
	# Reparent to the train and sync position
	player.set_as_top_level(true)
	player.last_train_pos = player.current_train.global_position
	player.z_index = -10
	print("🚆 Entered BoardedState")

func Physics(delta: float) -> State:
	# Disable vertical movement
	player.velocity.y = 0

	# Allow limited walking inside the train
	#var direction := Input.get_axis("ui_left", "ui_right")
	##if direction != 0:
		##var speed = player.WALK_SPEED
		##if direction == player.run_direction and player.run_direction != 0:
			##speed = player.RUN_SPEED
	#player.velocity.x = direction * speed
	#player.sprite.scale.x = sign(direction)
	#else:
	player.velocity.x = 0

	# Move with train
	var train_pos = player.current_train.global_position
	var delta_pos = train_pos - player.last_train_pos
	player.global_position += delta_pos
	player.last_train_pos = train_pos

	#player.move_and_slide();

	return null

func HandleInput(event: InputEvent) -> State:
	if event.is_action_pressed(player.interaction_key):
		print("🚪 Disembarking...")
		player.disembark(player.current_train)
		player.z_index = 10;
		return player.state_machine.get_node("IdleState")

	if event is InputEventScreenTouch and event.pressed:
		player.handle_touch(event.position)

	return null

func Exit() -> void:
	player.z_index = 10;
