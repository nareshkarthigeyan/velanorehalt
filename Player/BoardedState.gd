class_name BoardedState
extends State

var just_boarded := true

func Enter() -> void:
	# Snap to boarding marker
	if player.boarding_marker:
		player.global_position = player.boarding_marker.global_position

	# Set top-level to preserve global transform during reparenting
	player.set_as_top_level(true)

	# Reparent to train if needed
	if player.get_parent() != player.current_train:
		player.get_parent().remove_child(player)
		player.current_train.add_child(player)
		player.set_as_top_level(true)  # Must call again after reparenting

	# Sync train position
	player.last_train_pos = player.current_train.global_position
	player.z_index = -10

	print("🚆 Entered BoardedState")

	# Cooldown to prevent immediate disembark
	just_boarded = true
	await get_tree().create_timer(0.2).timeout
	just_boarded = false
	
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
	if just_boarded:
		return null

	if event.is_action_pressed(player.interaction_key):
		print("🚪 Disembarking...")
		#player.disembark(player.current_train)
		return player.state_machine.get_node("IdleState")

	if event is InputEventScreenTouch and event.pressed:
		player.handle_touch(event.position)

	return null

func Exit() -> void:
	if player.get_parent() == player.current_train:
		var pos = player.global_position
		player.current_train.remove_child(player)

		player.main_scene.add_child(player)

		player.global_position = pos
		player.set_as_top_level(false)

		player.can_board = false
		#player.current_train = null
		#player.boarding_marker = null
		
	player.z_index = 10;
