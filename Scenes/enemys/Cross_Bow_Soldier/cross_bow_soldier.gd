extends CharacterBody2D

@onready var down: RayCast2D = $down
@onready var rigth: RayCast2D = $rigth
@onready var left: RayCast2D = $left
@onready var up: RayCast2D = $up
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var ray_cast_2d: RayCast2D = $NAV/RayCast2D
@onready var fire_timer: Timer = $NAV/Fire_Timer
@export var ammo : PackedScene
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@export var nav : NavigationAgent2D
@export var speed = 50
var target_node = null
@onready var arrow_spawn: Marker2D = $arrow_spawn

var bottle = preload("res://Scenes/Item/Bottle/bottle_collectable.tscn")
var rubber = preload("res://Scenes/Item/Rubber/rubber_collectable.tscn")


var player = null 
var attacking = false
var attacked = false
var alive = true 

var receives_knockback = false
var knock_scale = 2.0

var health = 100


enum States{
	IDLE,
	SHOOTING,
	AIMING,
	FLEEING,
	FOLLOWING,
}

var current_state = States.IDLE

func ready() -> void:
	add_to_group("enemy")

func _physics_process(_delta: float) -> void:
	left.global_rotation = 0
	rigth.global_rotation = 0
	down.global_rotation = 0
	up.global_rotation = 0
	if alive && is_path_clear():  # Check if path to player is clear
		aim()
		fleeing()
		following()
		damage()
		_is_alive()
		check_collision()
		idle()
	else:
		avoid_obstacle()  # Avoid obstacles
		
	
		
func aim():
	if alive == true:
		if player != null && current_state != States.FLEEING:
			ray_cast_2d.target_position = to_global(player.position)
			look_at(player.get_global_position())
			global_rotation_degrees += -90
		
		
	
func fleeing():
	if alive == true:
		if player != null && current_state == States.FLEEING:
			position -= (player.position - position) / speed / 5
			look_at(player.get_global_position())
			global_rotation_degrees -= -90
			
			
			$AnimatedSprite2D.play("walk")


func following():
	if alive == true:
		if player != null && current_state == States.FOLLOWING:
			position += (player.position - position) / speed / 5
			$AnimatedSprite2D.play("walk")
			look_at(player.get_global_position())
			global_rotation_degrees += -90
			WorldManager.player_in_combat = true

func idle():
	if alive == true:
		if current_state == States.IDLE:
			$AnimatedSprite2D.play("idle")

func damage():
	if alive == true && attacked == true:
		health -= WorldManager.Player_Damage
		cpu_particles_2d.emitting = true
		

func _is_alive():
	if health <= 0:
		$AnimatedSprite2D.play("death")
		alive = false
		WorldManager.player_in_combat = false
		
		var new_rubber = rubber.instantiate()
		get_parent().add_child(new_rubber)  # Add to the world instead of enemy
		new_rubber.global_position = Vector2(global_position.x - 40, global_position.y)

		var new_bottle = bottle.instantiate()
		get_parent().add_child(new_bottle)  # Add to the world instead of enemy
		new_bottle.global_position = Vector2(global_position.x + 40, global_position.y)
		await get_tree().create_timer(1).timeout
		self.queue_free()

func check_collision():
	if ray_cast_2d.get_collider() == player and fire_timer.is_stopped():
		fire_timer.start()
	elif ray_cast_2d.get_collider() != player and fire_timer.is_stopped():
		fire_timer.stop()

func Cross_Bow_Soldier():
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("Player"):
		player = body
		current_state = States.SHOOTING
		

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("Player"):
		player = body
		current_state = States.FOLLOWING

func _on_fire_timer_timeout() -> void:
	shoot()

func shoot():
	if alive == true:
		if player != null && current_state == States.SHOOTING:
			var bullet = ammo.instantiate()
			get_parent().get_parent().add_child(bullet)
			bullet.global_position = arrow_spawn.global_position
			var shooting_dir = (player.global_position - global_position).normalized()
			bullet.set_direction(shooting_dir)
			$AnimatedSprite2D.play("attacking")

func _on_danger_close_body_entered(body: Node2D) -> void:
	if body.has_method("Player"):
		player = body
		current_state = States.FLEEING
		
		

func _on_danger_close_body_exited(body: Node2D) -> void:
	if body.has_method("Player"):
		player = body
		current_state = States.SHOOTING


func _on_chase_body_entered(body: Node2D) -> void:
	if body.has_method("Player"):
		player = body
		current_state = States.FOLLOWING

func _on_chase_body_exited(body: Node2D) -> void:
	if body.has_method("Player"):
		player = body
		current_state = States.IDLE

func _on_cross_e_hit_area_entered(area: Area2D) -> void:
	if area && area.name == "Player_Attack_HitBox" && WorldManager.player_current_attack == true :
		attacked = true
		receives_knockback = true
		KnockBack(area.global_position)

func _on_cross_e_hit_area_exited(area: Area2D) -> void:
	if area && area.name == "Player_Attack_HitBox" && WorldManager.player_current_attack == true :
		attacked = false
		
		
func KnockBack(damage_dir: Vector2):
	if receives_knockback:
		var knockback_dir = damage_dir.direction_to(self.global_position)
		var knockback_strength = 35 * knock_scale
		var knockback = knockback_dir * knockback_strength
		
		global_position += knockback
	
func is_path_clear() -> bool:
	var rays = [down, rigth, left, up]
	for ray in rays:
		if ray.is_colliding():
			var collider = ray.get_collider()
			if collider and not collider.is_in_group("enemy"):
				return false
	return true

func avoid_obstacle():
	if down.is_colliding():
		position += Vector2(0, -speed) / 10
	elif up.is_colliding():
		position += Vector2(0, speed) / 10
	elif rigth.is_colliding():
		position += Vector2(-speed, 0) / 10
	elif left.is_colliding():
		position += Vector2(speed, 0) / 10
