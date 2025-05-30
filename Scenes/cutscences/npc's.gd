extends Node2D

@export var camera : Camera2D
@export var activation_distance: float = 2000.0

func _process(_delta):
	for npc in get_children():
		if not npc is Node2D:
			continue

		var dist = camera.get_target_position().distance_to(npc.global_position)

		if dist <= activation_distance:
			npc.visible = true
			npc.set_process(true)
		else:
			npc.visible = false
			npc.set_process(false)
