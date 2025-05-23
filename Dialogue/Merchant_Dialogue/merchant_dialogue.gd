extends Control

@export_file("*.json") var M_D_file

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


var dialogue = []
var current_dialogue_id = 0
var dia_active = false


func _ready():
	$NinePatchRect.visible = false
	$NinePatchRect/TextureButton.visible = false
	$"NinePatchRect/unFollow Text".visible  = false
	$NinePatchRect/Text.visible = false
	$NinePatchRect/Name.visible = false
	$"NinePatchRect/Follow Text".visible = false
	
func _process(_delta):
	pass
	
			

func start():
	if dia_active:
		return
	dia_active = true
	$NinePatchRect.visible = true
	dialogue = load_dialogue()
	current_dialogue_id = -1 
	next_script()


func load_dialogue():
	var file = FileAccess.open("res://Dialogue/Merchant_Dialogue/merchant_dialogue1.json", FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content
	

func _input(event):
	if !dia_active:
		return
		
	if event.is_action_pressed("ui_accept") || Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		audio_stream_player.play()
		next_script()


func next_script():
	current_dialogue_id += 1
	
	if current_dialogue_id == 2:
		$NinePatchRect/TextureButton.visible = true
		$"NinePatchRect/TextureButton".visible = true
		$NinePatchRect/Text.visible = true
		$NinePatchRect/Name.visible = true
		$"NinePatchRect/Follow Text".visible = true
	
	if current_dialogue_id >= len(dialogue):
		dia_active = false
		$NinePatchRect.visible = false
		$"NinePatchRect/TextureButton".visible = false
		current_dialogue_id = -1 
		WorldManager.player_talking_Merchant = false
		emit_signal("end_dialogue")
		return
	
	$NinePatchRect/Name.text = dialogue[current_dialogue_id]['name']
	$NinePatchRect/Text.text = dialogue[current_dialogue_id]['text']

func reset():
	current_dialogue_id = -1 

func _on_texture_button_pressed() -> void:
	audio_stream_player.play()
	WorldManager.Merchant_follow_player = !WorldManager.Merchant_follow_player

	$"NinePatchRect/Follow Text".visible = !WorldManager.Merchant_follow_player
	$"NinePatchRect/unFollow Text".visible = WorldManager.Merchant_follow_player
