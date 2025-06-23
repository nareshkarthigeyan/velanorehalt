class_name JumpState
extends State

var has_jumped := false
const JUMP_VELOCITY = -400.0

func Enter() -> void:
	if player.is_on_floor():
		player.velocity.y = player.JUMP_VELOCITY
		has_jumped = true
		player.AnimatedPlayerSprite.play("jump")

func Physics(delta: float) -> State:
	# Apply gravity
	player.velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta
	

	# Jump
	if Input.is_action_just_pressed("ui_accept") and player.is_on_floor():
		player.velocity.y = JUMP_VELOCITY
		
	if not player.is_on_floor():
		player.velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta
	return null
