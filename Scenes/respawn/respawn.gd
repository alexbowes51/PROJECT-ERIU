extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_texture_button_pressed() -> void:
	var player = get_tree().get_current_scene().get_node("Player")
	if player:
		player.respawn_player()
	else:
		push_error("Could not find Player node to respawn.")


func _on_texture_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main Menu/Main Menu.tscn")
