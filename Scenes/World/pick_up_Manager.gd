extends Node2D

@export var player: Node2D  # Drag your player node here in the inspector
@export var activation_distance: float = 1000.0

func _process(_delta):
	for pick_up in get_children():
		if not pick_up is Node2D:
			continue

		var dist = player.global_position.distance_to(pick_up.global_position)

		if dist <= activation_distance:
			pick_up.visible = true
			pick_up.set_process(true)
		else:
			pick_up.visible = false
			pick_up.set_process(false)
