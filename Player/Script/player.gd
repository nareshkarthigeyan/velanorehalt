class_name Player extends CharacterBody2D

const WALK_SPEED = 100.0
const RUN_SPEED = 350.0
const DOUBLE_TAP_TIME = 0.3  # in seconds

@onready var AnimatedPlayerSprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite = $AnimatedSprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine
var last_input_time = {
	"ui_left": -1.0,
	"ui_right": -1.0
}

var run_direction = 0

func _ready() -> void:
	state_machine.Initialize(self)

func _unhandled_input(event):
	state_machine._unhandled_input(event)

## FOR TOUCHSCREEN:
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


func _physics_process(delta: float) -> void:
	state_machine._physics_process(delta)
	move_and_slide()
