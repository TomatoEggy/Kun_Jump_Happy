extends CountButton

var nodes: Array[Node]

func _ready() -> void:
	super()
	for node in owner.get_children():
		if node is RigidBody2D:
			nodes.append(node)

func _on_count_changed(count: int) -> void:
	if count == 1:
		owner.change_tip()
		for node in nodes:
				node.gravity_scale = 1
		for node in nodes:
				node.apply_central_impulse(Vector2(450,150).direction_to(node.global_position) * 400.0)
	elif count == 2:
		for node in nodes:
			node.apply_central_impulse(Vector2(0, -1) * 1000)
	elif count == 3:
		owner.can_press_button = true
