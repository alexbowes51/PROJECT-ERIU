extends Control

@onready var spirits_liberated: Label = $"NinePatchRect/Spirits Liberated"
@onready var answer_wrong: Label = $NinePatchRect/Answer_Right2
@onready var answer_right: Label = $NinePatchRect/Answer_Right


func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if WorldManager.finished_talking_Farmer && WorldManager.finished_talking_Fisher_man && WorldManager.finished_talking_Polition && WorldManager.finished_talking_tiktoker:
		WorldManager.game_over = true
		visible = true
		spirits_liberated.text = "Spirits Liberated " + str(WorldManager.NPC_Talked_to) + " / 4"
		answer_right.text = "Questions You Got Correct " + str(WorldManager.rigth_answers) + " / 4"
		answer_wrong.text = "Questions You Got Wrong " + str(WorldManager.wrong_answers) + " / 4"


func _on_try_agin_pressed() -> void:
	restart()
	get_tree().reload_current_scene()


func _on_return_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main Menu/Main Menu.tscn")


func restart():
	WorldManager.finished_talking_Farmer = false
	WorldManager.finished_talking_Fisher_man = false
	WorldManager.finished_talking_tiktoker = false
	WorldManager.finished_talking_Polition = false
	WorldManager.NPC_Talked_to = 0
	WorldManager.rigth_answers = 0
	WorldManager.wrong_answers = 0
