extends Node2D


func _on_safe_zone_1_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		WorldManager.player_attackable = false


func _on_safe_zone_1_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		WorldManager.player_attackable = true


func _on_safe_zone_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		WorldManager.player_attackable = false


func _on_safe_zone_2_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		WorldManager.player_attackable = true


func _on_safe_zone_3_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		WorldManager.player_attackable = false


func _on_safe_zone_3_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		WorldManager.player_attackable = true


func _on_safe_zone_4_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		WorldManager.player_attackable = false


func _on_safe_zone_4_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		WorldManager.player_attackable = true
