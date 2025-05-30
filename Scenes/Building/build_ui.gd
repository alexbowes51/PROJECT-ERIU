extends Control

var is_open = false
@onready var wood_label: Label = $NinePatchRect/Wood/Wood_Label
@onready var bottles_label: Label = $NinePatchRect/Bottles/Bottles_Label
@onready var rubber_label: Label = $NinePatchRect/Rubber/Rubber_Label


func _ready():
	pass


func open():
	print("open")
	visible = true
	is_open = true
	WorldManager.Build_mode = true
	

func close():
	print("close")
	WorldManager.Build_mode = false
	visible = false
	is_open = false


	
func _process(_delta):
		if Input.is_action_just_pressed("build_mode") && WorldManager.player_in_build_zone == true :
			if is_open:
				close()
			else:
				open()
				
		if is_open == true && WorldManager.player_in_build_zone == false:
			close()
	
		
		
		if WorldManager.player_talking_Merchant == true && WorldManager.player_talking_Black_Smith == true:
			close()

		if $NinePatchRect/GridContainer/house.button_pressed:
			WorldManager.building = "house"
			if wood_label && bottles_label:
				wood_label.text = str(2)
				bottles_label.text = str(2)
			
			
		if $NinePatchRect/GridContainer/farm.button_pressed:
			WorldManager.building = "farm"
			if wood_label && bottles_label:
				wood_label.text = str(2)
				bottles_label.text = str(2)

		if $NinePatchRect/GridContainer/black_smith.button_pressed:
			WorldManager.building = "black_smith"
			if wood_label && bottles_label:
				wood_label.text = str(2)
				bottles_label.text = str(2)
