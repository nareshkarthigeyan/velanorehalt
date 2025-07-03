class_name JumpState
extends State

var has_jumped := false
const JUMP_VELOCITY = -400.0

func Enter() -> void:
	#print("In Jump State!")
	if player.is_on_floor():
		player.velocity.y = JUMP_VELOCITY
		has_jumped = true
		#player.AnimatedPlayerSprite.play("jump")

func Physics(delta: float) -> State:
	
	if Input.is_action_just_pressed("ui_accept") and player.is_on_floor():
		player.velocity.y = JUMP_VELOCITY
		
	if not player.is_on_floor():
		player.velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta
	#return null
	#
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction != 0:
		#if player.velocity.x == direction * player.WALK_SPEED && player.velocity.x != 0:
			#player.velocity.x = direction * player.WALK_SPEED
		#elif direction == player.run_direction and player.run_direction != 0:
			#player.velocity.x = direction * player.RUN_SPEED
	##player.sprite.scale.x = sign(direction)
	
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		# Choose correct speed (walk or run)
		var speed = player.WALK_SPEED
		if direction == player.run_direction and player.run_direction != 0:
			speed = player.RUN_SPEED
		# Optional: smoother air control
		var air_control := 0.5
		player.velocity.x = lerp(player.velocity.x, direction * speed, air_control)
			# Flip sprite
		player.sprite.scale.x = sign(direction)
	
	#if direction == 0:
		#player.AnimatedPlayerSprite.play("idle")
	
	if player.is_on_floor():
		if player.velocity.x == direction * player.WALK_SPEED && player.velocity.x != 0:
			return player.state_machine.get_node("WalkState")
		elif direction == player.run_direction and player.run_direction != 0:
			return player.state_machine.get_node("RunState")
		else:
			return player.state_machine.get_node("IdleState")
	return null

func HandleInput(event: InputEvent) -> State:
	if event.is_action_pressed(player.interaction_key):
		if player.can_board and player.current_train and player.boarding_marker:
			return player.state_machine.get_node("BoardedState")

	if event is InputEventScreenTouch and event.pressed:
		player.handle_touch(event.position)

	return null
