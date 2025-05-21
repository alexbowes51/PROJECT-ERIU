extends TileMapLayer

@export var active_distance := 512.0 

var player: Node = null

func _ready():
	set_process(true)

func _process(delta):
	if not player:
		return
	var distance = position.distance_to(player.global_position)
	visible = distance <= active_distance
