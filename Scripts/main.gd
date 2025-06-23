extends Node2D

@export var train_scene: PackedScene = preload("res://Train/Train.tscn")
@export var station_path: NodePath = "Station"
@export var train_spawn_x: float = 10000.0
@export var train_delay: float = 2.0

func _ready():
	await get_tree().create_timer(train_delay).timeout
	spawn_train()

func spawn_train():
	var train_instance = train_scene.instantiate()
	var station = get_node(station_path)

	train_instance.position = Vector2(train_spawn_x, station.position.y)
	add_child(train_instance)

	if train_instance is Train:
		var train = train_instance as Train
		train.train_cycle(station.global_position)
		print("Train cycle started!")
	else:
		push_error("❌ Train instance is missing the Train.gd script!")
		
	await get_tree().create_timer(300).timeout
	spawn_train()
