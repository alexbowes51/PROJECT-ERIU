extends Node2D

@onready var camera_2d: Camera2D = $Path2D/PathFollow2D/Camera2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D
@onready var introdialogue: Control = $Path2D/PathFollow2D/Camera2D/CanvasLayer/Control

var stop_points = [0,0.1115,0.2373,0.423,0.4801,0.5587,0.6658,1]
var current_point = 0
var is_stop = false
var pause_timer = 0.0
var pause_duration = 5.0

var path_follow = false
var open_scene = false
var played = false
var played2 = false

func ready():
	pass
	
func cutscenceopening():
	if !played:
		played = true
		animation_player.play("fade_in")
		open_scene = true
		path_follow = true
		camera_2d.enabled = true
	
	
func cutsceneclose():
	if !played2:
		played2 = true
		animation_player.play("Fade_out")
		open_scene = false
		path_follow = false
		if animation_player.animation_finished:
			get_tree().change_scene_to_file("res://Scenes/World/world.tscn")
		
	
func _process(delta: float) -> void:
	cutscenceopening()
	if path_follow and !is_stop:
		path_follow_2d.progress_ratio += delta * 0.02 # smoother movement
		introdialogue.visible = false
		
		# Check if it's time to stop
		if current_point < stop_points.size():
			var stop_value = stop_points[current_point]
			if path_follow_2d.progress_ratio >= stop_value:
				is_stop = true
				introdialogue.visible = true
				pause_timer = 0.0
				print("Paused at: ", stop_value)
				
				if introdialogue:
					introdialogue.show_dialogue(current_point)
				
					# Optional: show dialogue here
					current_point += 1
					WorldManager.Intro_stop_index += 1

		if path_follow_2d.progress_ratio >= 0.999:
			await cutsceneclose()
		elif is_stop:
			pause_timer += delta
			if pause_timer >= pause_duration:
				is_stop = false  # Resume moving


func _unhandled_input(event):
	if is_stop:
		if event.is_action("touch_activation"):
			if introdialogue:
				if introdialogue.dia_active:
					introdialogue.next_script()
					is_stop = false
