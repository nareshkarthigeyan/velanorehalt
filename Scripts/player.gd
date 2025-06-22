extends CharacterBody2D

const WALK_SPEED = 100.0
const RUN_SPEED = 300.0
const JUMP_VELOCITY = -500.0
const DOUBLE_TAP_TIME = 0.3  # in seconds

@onready var anim = $AnimatedSprite2D
@onready var sprite = $AnimatedSprite2D

var last_input_time = {
	"ui_left": -1.0,
	"ui_right": -1.0
}

var run_direction = 0

# TEMP
func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			handle_touch(event.position)

func handle_touch(pos: Vector2):
	var screen_width = get_viewport_rect().size.x
	var screen_height = get_viewport_rect().size.y

	# Left half → move left
	if pos.x < screen_width * 0.4:
		Input.action_press("ui_left")
		Input.action_release("ui_right")
		run_direction = -1

	# Right half → move right
	elif pos.x > screen_width * 0.6:
		Input.action_press("ui_right")
		Input.action_release("ui_left")
		run_direction = 1

	# Middle top area → jump
	elif pos.y < screen_height * 0.3:
		Input.action_press("ui_accept")

func _input(event):
	if event is InputEventScreenTouch and not event.pressed:
		# Release all actions when finger lifted
		Input.action_release("ui_left")
		Input.action_release("ui_right")
		Input.action_release("ui_accept")
		
		#TEMP

func _physics_process(delta: float) -> void:
	var current_time = Time.get_ticks_msec() / 1000.0  # Convert to seconds

	# Apply gravity
	if not is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Direction input
	var direction = Input.get_axis("ui_left", "ui_right")
	var input_pressed = ""

	if Input.is_action_just_pressed("ui_left"):
		input_pressed = "ui_left"
	elif Input.is_action_just_pressed("ui_right"):
		input_pressed = "ui_right"

	# Handle double-tap for running
	if input_pressed != "":
		if current_time - last_input_time[input_pressed] <= DOUBLE_TAP_TIME:
			if input_pressed == "ui_right":
				run_direction = 1
			else:
				run_direction = -1
		else:
			run_direction = 0

		last_input_time[input_pressed] = current_time
	
	# TEMPORARY BULLSHIT:
	

	# Movement and animation
	if direction != 0:
		var speed = WALK_SPEED
		if direction == run_direction and run_direction != 0:
			speed = RUN_SPEED

		velocity.x = direction * speed

		# Flip sprite
		if direction > 0:
			sprite.scale.x = 1
		else:
			sprite.scale.x = -1

		# Animation
		if speed == RUN_SPEED:
			if anim.animation != "run":
				anim.play("run")
		else:
			if anim.animation != "walk":
				anim.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
		if anim.animation != "idle":
			anim.play("idle")

	move_and_slide()
