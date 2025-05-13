extends Node2D

@export var spawns: Array[Spawner_Info] = []

@onready var player = get_tree().get_first_node_in_group("player")

var time := 0
var spawn_counters: Dictionary = {}

func _ready():
	for spawn in spawns:
		spawn_counters[spawn] = 0

func _on_timer_timeout():
	time += 1
	for spawn in spawns:
		if time >= spawn.time_s and time <= spawn.time_e:
			if spawn_counters[spawn] < spawn.enemy_spawn_delay:
				spawn_counters[spawn] += 1
			else:
				spawn_counters[spawn] = 0
				for i in spawn.enemy_num:
					var enemy = spawn.enemy.instantiate()
					enemy.global_position = get_random_position()
					add_child(enemy)
					print("spawned enemy")

func get_random_position() -> Vector2:
	var vpr = get_viewport_rect().size * randf_range(1.1, 1.4)
	var top_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y - vpr.y/2)
	var top_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y - vpr.y/2)
	var bottom_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y + vpr.y/2)
	var bottom_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y + vpr.y/2)

	var side = ["up", "down", "left", "right"].pick_random()
	var pos1: Vector2
	var pos2: Vector2

	match side:
		"up":
			pos1 = top_left
			pos2 = top_right
		"down":
			pos1 = bottom_left
			pos2 = bottom_right
		"left":
			pos1 = top_left
			pos2 = bottom_left
		"right":
			pos1 = top_right
			pos2 = bottom_right

	return Vector2(randf_range(pos1.x, pos2.x), randf_range(pos1.y, pos2.y))
