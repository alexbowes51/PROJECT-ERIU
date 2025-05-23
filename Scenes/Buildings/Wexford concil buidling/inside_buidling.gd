extends Node2D

@onready var control: Control = $Control
var entered = false

func _physics_process(_delta):
	if entered && Input.is_action_just_pressed("chat"):
		get_tree().change_scene_to_file("res://Scenes/World/world.tscn")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("Player"):
		control.visible = true
		entered = true
	


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("Player"):
		control.visible = false
		entered = false
