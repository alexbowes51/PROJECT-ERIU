extends CharacterBody2D


const speed = 30.25

var current_state = IDLE
@onready var control: Control = $Control

var is_roaming = true
var is_chatting = false
var player = null
var player_in_interact_range = false
var is_following_player = false

var dir = Vector2.RIGHT
var player_position : Vector2
var start_pos

enum {
	IDLE,
	FOLLOW,
	MOVE,
	NEW_DIR,
	RETURN_START
}

func _ready():
	randomize()
	start_pos = position
	control.visible = false


func _physics_process(delta):
	if WorldManager.player_talking_Gardai_m == true:
		control.visible = false
	
	if current_state == 0:
		$AnimatedSprite2D.play("Idle")
		
	elif current_state == 2 and !is_chatting:
		
		if dir.x == -1:
			$AnimatedSprite2D.play("Move")
			$AnimatedSprite2D.rotation = rad_to_deg(-90)
			
		if dir.x == 1:
			$AnimatedSprite2D.play("Move")
			$AnimatedSprite2D.rotation = rad_to_deg(90)
			
		if dir.y == -1:
			$AnimatedSprite2D.play("Move")
			$AnimatedSprite2D.rotation = rad_to_deg(-180)
			
		if dir.y == 1: 
			$AnimatedSprite2D.play("Move")
			$AnimatedSprite2D.rotation = rad_to_deg(0)
	
	if is_roaming:
		match  current_state:
			IDLE:
				pass
			NEW_DIR:
				dir = choose([Vector2.RIGHT,Vector2.UP,Vector2.LEFT,Vector2.DOWN])
			MOVE:
				move(delta)
			FOLLOW:
				position += (player.global_position - global_position) * speed * delta
				look_at(player.global_position)
				
			
	if player_in_interact_range:
		if Input.is_action_just_pressed("chat"):
			WorldManager.player_talking_Gardai_m = true
			is_roaming = false
			is_chatting = true
			$AnimatedSprite2D.play("Iteract")
			
	if WorldManager.finished_talking_Gardai_m == true:
		await get_tree().create_timer(3).timeout
		self.queue_free()

func choose(array):
	array.shuffle()
	return array.front()

func move(delta):
	if !is_chatting:
		position += dir * speed * delta


func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([0.5,1.0,1.5])
	current_state = choose([IDLE,NEW_DIR,MOVE])


func _on_merchant_dialogue_end_dialogue() -> void:
	is_chatting = false
	is_roaming = true


func _on_area_body_entered(body: Node2D) -> void:
	if body.has_method("Player"):
		player = body
		player_in_interact_range = true
		control.visible = true


func _on_area_body_exited(body: Node2D) -> void:
	if body.has_method("Player"):
		player_in_interact_range = false
		is_chatting = false
		is_roaming = true
		control.visible = false
