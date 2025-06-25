class_name PlayerStateMachine extends Node


var states : Array[ State ]
var prev_state : State
var current_state : State


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#process_mode = Node.PROCESS_MODE_DISABLED
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ChangeState(current_state.Process(delta));



func _physics_process(delta: float) -> void:
	ChangeState(current_state.Physics(delta));



func _unhandled_input(event: InputEvent) -> void:
	ChangeState(current_state.HandleInput(event))



func Initialize(_player: Player) -> void:
	states = []

	for c in get_children():
		if c is State:
			states.append(c)
			c.player = _player 

	if states.size() > 0:
		ChangeState(states[0])

	set_physics_process(true) 
		

func ChangeState(new_state: State) -> void:
	if new_state == null || new_state == current_state:
		return
		
	#if new_state == null:
		#print("State change skipped: new_state is null")
		#return
	#if new_state == current_state:
		#print("State change skipped: already in that state")
		#return
		
	if current_state:
		current_state.Exit();

	prev_state = current_state
	current_state = new_state
	current_state.Enter();
	
