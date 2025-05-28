extends CharacterBody2D

const speed = 30.25

var current_state = IDLE

var is_roaming = true
var is_chatting = false
var player = null

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


func _physics_process(delta):
	if current_state == 0:
		$AnimatedSprite2D.play("Idle")
		
	elif current_state == 2 and !is_chatting:
		
		if dir.x == -1:
			$AnimatedSprite2D.play("Walk")
			$AnimatedSprite2D.rotation = rad_to_deg(-90)
			
		if dir.x == 1:
			$AnimatedSprite2D.play("Walk")
			$AnimatedSprite2D.rotation = rad_to_deg(90)
			
		if dir.y == -1:
			$AnimatedSprite2D.play("Walk")
			$AnimatedSprite2D.rotation = rad_to_deg(-180)
			
		if dir.y == 1:
			$AnimatedSprite2D.play("Walk")
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
				
				

func choose(array):
	array.shuffle()
	return array.front()

func move(delta):
	if !is_chatting:
		position += dir * speed * delta

func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([0.5,1.0,1.5])
	current_state = choose([IDLE,NEW_DIR,MOVE])
