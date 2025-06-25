class_name State extends Node

static var player : Player

func _ready():
	pass


## What happens when player enters the state
func Enter() -> void:
	pass


## What happens when player exits the state
func Exit() -> void:
	pass

## What happens when player in in the state the state aka _process update
func Process(_delta: float) -> State:
	return null


func Physics(_delta: float) -> State:
	return null


func HandleInput(event: InputEvent) -> State:
	return null
