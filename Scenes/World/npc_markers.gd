extends Node2D

@onready var farmer_waypoint: Node2D = $Farmer_Waypoint
@onready var fisher_man_waypoint: Node2D = $FisherMan_Waypoint
@onready var polition_waypoint: Node2D = $Polition_Waypoint
@onready var infulencer_waypoint: Node2D = $Infulencer_Waypoint

func _ready():
	fisher_man_waypoint.visible = false
	polition_waypoint.visible = false
	infulencer_waypoint.visible = false
	
func _process(_delta):
	if WorldManager.finished_talking_Farmer:
		farmer_waypoint.visible = false
		fisher_man_waypoint.visible = true
	if WorldManager.finished_talking_Fisher_man:
		fisher_man_waypoint.visible = false
		polition_waypoint.visible = true
	if WorldManager.finished_talking_Polition:
		polition_waypoint.visible = false
		infulencer_waypoint.visible = true
	if WorldManager.finished_talking_Polition:
		polition_waypoint.visible = false
	
