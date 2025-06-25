class_name TrainStateMachine extends Node


var states : Array[ TrainState ]
var prev_state : TrainState
var current_state : TrainState


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#process_mode = Node.PROCESS_MODE_DISABLED
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_state != null:
		ChangeState(current_state.Process(delta));



func _physics_process(delta: float) -> void:
	if current_state != null:
		ChangeState(current_state.Physics(delta));



func _unhandled_input(event: InputEvent) -> void:
	if current_state != null:
		ChangeState(current_state.HandleInput(event))


func Initialize(_train: Train) -> void:
	states = []

	for c in get_children():
		if c is TrainState:
			states.append(c)
			print(c._name);
			c.train = _train 

	if states.size() > 0:
		ChangeState(states[0])

	#set_physics_process(true) 
		

func ChangeState(new_state: TrainState) -> void:
	if new_state == null || new_state == current_state:
		return
		
	if current_state:
		current_state.Exit();

	prev_state = current_state
	current_state = new_state
	current_state.Enter();
	
