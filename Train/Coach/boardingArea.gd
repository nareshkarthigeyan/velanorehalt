extends Area2D

@onready var train = get_parent().get_parent()

func _on_body_entered(body):
	# Ignore all non-CharacterBody2D
	if not body is CharacterBody2D:
		return

	# Filter to only allow Player
	if not body is Player:
		return

	if not body.is_inside_train():
		print("🟢 Boarding possible at", name)
		body.can_board = true
		body.current_train = train
		body.boarding_marker = $Marker2D

func _on_body_exited(body):
	if not body is Player:
		return

	if not body.is_inside_train():
		body.can_board = false
