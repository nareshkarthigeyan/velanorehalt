class_name WalkState
extends State

func Enter():
	#print("In Walk State!")
	player.AnimatedPlayerSprite.play("walk")
	
func Physics(delta: float) -> State:
	var direction = Input.get_axis("ui_left", "ui_right")

	if not player.is_on_floor() or Input.is_action_pressed("ui_accept"):
		player.jump_requested = true
		player.jump_cancelled = false
		player.delayed_jump()
		return null
		
	if Input.is_action_just_released("ui_accept"):
		player.jump_cancelled = true

	if direction == 0:
		return player.state_machine.get_node("IdleState")

	if direction == player.run_direction and player.run_direction != 0:
		return player.state_machine.get_node("RunState")

	player.velocity.x = direction * player.WALK_SPEED
	player.sprite.scale.x = sign(direction)
	return null
	
func HandleInput(event: InputEvent) -> State:
	if event is InputEventScreenTouch:
		if event.pressed:
			player.handle_touch(event.position)	
	return null
