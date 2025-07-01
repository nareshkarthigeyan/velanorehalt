extends Area2D

@onready var train = get_parent().get_parent()

func _on_body_entered(body):
	print("🟡 ENTERED BODY:", body.name, "| TYPE:", body.get_class())
	print("🚆 My train is:", train)

	if body.get_class() == "CharacterBody2D" and not body.is_inside_train():
		print("✅ Setting player boarding vars")
		body.can_board = true
		body.current_train = train
		body.boarding_marker = get_node("Marker2D")

func _on_body_exited(body):
	#if body.get_class() == "CharacterBody2D" and not body.is_inside_train():
		#print("🔴 Player left door area")
		#body.can_board = false
		#body.current_train = null
		#body.boarding_marker = null
		pass
