extends Node2D

var player 
var minimap 

#preloading the house / farm 
var farm_scene = preload("res://Scenes/Buildings/farm/farm.tscn")
var house_scene = preload("res://Scenes/Buildings/house 1/house.tscn")
var black_smith = preload("res://Scenes/Buildings/Black_smiths/blacksmith.tscn")

var black_smith_built = false

@onready var day_night_cycle = $"DAY+NIGHT CYCLE"
@onready var time_label = $MiniMap/Time_Label

var sigma = preload("res://Scenes/enemys/Boss/scottish_giant.tscn")
var spawn_sigma = false
@export var enable_cycle: bool = true

#tilemap variables
var building = "None"
var player_in_build_zone = false


#player world varibales
var player_current_attack = false
var Build_mode = false
var player_weapon = "none"
var player_healed = false

var player_in_village = false
var player_in_combat = false

#teleport variables
var tp_Wp1_A = "A"
var tp_Wp2_A = "A"

var Wp1_tp = false
var Wp2_tp = false

var Wp1_A = Vector2(6751,14407)
var Wp1_B = Vector2(18349,1107)

var Wp2_A = Vector2(6849,14543)
var Wp2_B = Vector2(1948,1146)

var home_spawn = Vector2(10871,1918)
var villages_Cleared : int = 0
var waypoints_Cleared : int = 0
var waypoint1clear : bool = false
var waypoint2clear : bool = false

#npc varibales 
var player_is_talking = false
var Merchant_follow_player = false
var player_talking_Merchant = false
var player_finished_talking_M = false

var Black_smith_follow_player = false
var player_talking_Black_Smith = false
var player_finsihed_talking_BS = false
var Bs_shop = false
var Item_Selling = "none"

var player_talking_Farmer = false
var player_talking_fisher_man = false
var player_talking_Polition = false
var player_talking_tiktoker = false

var finished_talking_Farmer = false
var finished_talking_Fisher_man = false
var finished_talking_Polition = false
var finished_talking_tiktoker = false

var reading_book = false

var player_needs_healing = false

var Intro_stop_index = 0

var Settings = false
var Objective = true
var Player_Damage = 20

var player_attackable = true

func _ready():
	minimap = $MiniMap
	player = $Player
	
	if player:
		minimap.player_node = player
	
	if enable_cycle:
		_setup_cycle()
	else:
		Day_Night_Manager.visible = false
		Day_Night_Manager.process_mode = Node.PROCESS_MODE_DISABLED


func _setup_cycle() -> void:
	if day_night_cycle:
		day_night_cycle.time_change.connect(change_time)
	
func change_time(_hour: float, time_string: String) -> void:
	if time_label:
		time_label.text = time_string

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not spawn_sigma and waypoints_Cleared == 2 and villages_Cleared == 2:
		spawn_boss()
			
	if Build_mode == true && player_in_build_zone == true && Input.is_action_just_pressed("build"):
		build()
	


func spawn_boss():
	if spawn_sigma:
		return  # Prevent multiple spawns
	
	print("Spawning boss...")  # Debugging
	var scottish_sigma = sigma.instantiate()
	var bosses_node = get_node("/root/world/Bosses")
	
	if bosses_node:
		bosses_node.add_child(scottish_sigma)
		scottish_sigma.position = Vector2(4337, 12950)
		print("Boss spawned at:", scottish_sigma.position)
		spawn_sigma = true  # Mark the boss as spawned
	else:
		print("Error: 'Bosses' node not found!")

func build():
	if building == "house":
		var built_house = house_scene.instantiate()
		add_child(built_house)
		building = "none"
				
	if building == "farm":
		var built_farm = farm_scene.instantiate()
		add_child(built_farm)
		building = "none"
		
	if building == "black_smith" && black_smith_built == false:
		var built_black = black_smith.instantiate()
		add_child(built_black)
		building = "none"
	


func _on_build_zone_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		WorldManager.player_in_build_zone = true
		WorldManager.player_attackable = false
		


func _on_build_zone_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		WorldManager.player_in_build_zone = false
		WorldManager.player_attackable = true
