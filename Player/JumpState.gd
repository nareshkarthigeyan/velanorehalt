class_name JumpState
extends State

var has_jumped := false
const JUMP_VELOCITY = -400.0

func Enter() -> void:
	print("In Jump State!")
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
	if player.is_on_floor():
		var direction = Input.get_axis("ui_left", "ui_right")
		if player.velocity.x == direction * player.WALK_SPEED && player.velocity.x != 0:
			return player.state_machine.get_node("WalkState")
		elif direction == player.run_direction and player.run_direction != 0:
			return player.state_machine.get_node("RunState")
		else:
			return player.state_machine.get_node("IdleState")
	return null

func HandleInput(event: InputEvent) -> State:
	if event is InputEventScreenTouch:
		if event.pressed:
			player.handle_touch(event.position)	
	return null
