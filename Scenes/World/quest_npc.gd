extends Node2D

@export var player: Node2D  # Drag your player node here in the inspector
@export var activation_distance: float = 500.0

func _process(_delta):
	for npc in get_children():
		if not npc is Node2D:
			continue

		var dist = player.global_position.distance_to(npc.global_position)

		if dist <= activation_distance:
			npc.visible = true
			npc.set_process(true)
		else:
			npc.visible = false
			npc.set_process(false)
