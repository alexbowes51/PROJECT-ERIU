extends TileMapLayer

@export var active_distance := 512.0 
@export var camera : Camera2D


func _ready():
	set_process(true)

func _process(_delta):
	if not camera:
		return
	var distance = self.position.distance_to(camera.position)
	visible = distance <= active_distance
