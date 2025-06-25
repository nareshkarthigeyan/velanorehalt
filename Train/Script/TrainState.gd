class_name TrainState extends Node

static var train : Train

func _ready():
	pass


## What happens when player enters the state
func Enter() -> void:
	pass


## What happens when player exits the state
func Exit() -> void:
	pass

## What happens when player in in the state the state aka _process update
func Process(_delta: float) -> TrainState:
	return null


func Physics(_delta: float) -> TrainState:
	return null


func HandleInput(event: InputEvent) -> TrainState:
	return null
