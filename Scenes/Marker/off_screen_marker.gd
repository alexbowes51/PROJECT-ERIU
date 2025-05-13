extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var icon: Sprite2D = $Sprite2D/icon

func ready():
	visible = false

func _physics_process(delta):

	var canvas = get_canvas_transform()
	var top_left = -canvas.origin / canvas.get_scale()
	var size = get_viewport_rect().size
	
	var bounds = Rect2(top_left, size)
	set_marker_position(bounds)
	set_marker_rotation()
	

func set_marker_position(bounds: Rect2):
	var clamped_position = Vector2(
		clamp(global_position.x, bounds.position.x, bounds.end.x),
		clamp(global_position.y, bounds.position.y, bounds.end.y)
	)
	sprite_2d.global_position = clamped_position
	
	if visible == true:
		visible = not bounds.has_point(global_position)

func set_marker_rotation():
	var angle = (global_position - sprite_2d.global_position).angle()
	sprite_2d.global_rotation = angle
	icon.global_rotation = 0


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("Player"):
		visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("Player"):
		visible = false
