extends Sprite2D

@onready var parent: Node2D = $".."

var pressing := false
@export var maxlength := 55.0
@export var deadzone := 20.0

func _ready():
	maxlength *= parent.scale.x

func _process(delta):
	if pressing:
		var mouse_pos = get_global_mouse_position()
		var direction = mouse_pos - parent.global_position
		var distance = direction.length()

		if distance <= maxlength:
			global_position = mouse_pos
		else:
			direction = direction.normalized()
			global_position = parent.global_position + direction * maxlength

		_calculate_vector()
	else:
		# Smoothly return joystick to center
		global_position = lerp(global_position, parent.global_position, delta * 50)
		parent.posVector = Vector2.ZERO

func _calculate_vector():
	var offset_gom = global_position - parent.global_position
	var vec := Vector2.ZERO

	if abs(offset_gom.x) >= deadzone:
		vec.x = offset_gom.x / maxlength
	if abs(offset_gom.y) >= deadzone:
		vec.y = offset_gom.y / maxlength

	parent.posVector = vec

func _on_button_button_down():
	pressing = true

func _on_button_button_up():
	pressing = false
