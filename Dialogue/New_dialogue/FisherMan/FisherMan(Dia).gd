extends Control

@export_file("*.json") var Gm_D_file

@onready var slider : HSlider = $NinePatchRect/slider
@onready var answer_label : Label = $NinePatchRect/Answer
@onready var submit_btn : TextureButton = $NinePatchRect/TextureButton
@onready var name_label : RichTextLabel = $NinePatchRect/Name
@onready var text_label : RichTextLabel = $NinePatchRect/Text

var dialogue : Array = []
var current_dialogue_id : int = -1
var dia_active: bool  = false

func _ready() -> void:
	_hide_all()
	slider.min_value = 0
	slider.step = 1

func _hide_all() -> void:
	$NinePatchRect.visible = false
	slider.visible = false
	answer_label.visible = false
	submit_btn.visible = false
	name_label.visible = false
	text_label.visible = false

func start() -> void:
	if dia_active:
		return
	dia_active = true
	dialogue = _load_dialogue()
	current_dialogue_id = -1
	_next_script()

func _load_dialogue() -> Array:
	var file = FileAccess.open(Gm_D_file, FileAccess.READ)
	if not file:
		push_error("Couldn’t open JSON: " + str(Gm_D_file))
		return []
	var content = file.get_as_text()
	var parsed  = JSON.parse_string(content)
	if typeof(parsed) != TYPE_ARRAY:
		push_error("Dialogue JSON must be an Array, got: %s" % typeof(parsed))
		return []
	return parsed

func _input(event):
	if not dia_active:
		return
	if event.is_action_pressed("chat"):
		_next_script()

func _next_script() -> void:
	if not dia_active:
		return

	current_dialogue_id += 1
	if current_dialogue_id >= dialogue.size():
		_end_dialogue()
		return

	var entry = dialogue[current_dialogue_id]
	$NinePatchRect.visible = true
	name_label.visible = true
	text_label.visible = true

	if entry.get("quiz", false):
		text_label.text = entry.get("question", "True or False?")
		name_label.text = entry.get("name", "")
		var opts = entry.get("answers", [])
		slider.max_value = max(opts.size() - 1, 0)
		slider.value = 0
		slider.visible = true
		answer_label.text = opts[0]
		answer_label.visible = true
		submit_btn.visible = true
	else:
		slider.visible = false
		answer_label.visible = false
		submit_btn.visible = false
		name_label.text = entry.get("name", "")
		text_label.text = entry.get("text", "")

func _end_dialogue() -> void:
	_hide_all()
	dia_active = false
	current_dialogue_id = -1
	WorldManager.player_talking_Gardai_m = false
	WorldManager.finished_talking_Gardai_m = true
	emit_signal("end_dialogue")

func _on_slider_value_changed(value: float) -> void:
	if not dia_active:
		return
	var opts = dialogue[current_dialogue_id].get("answers", [])
	var idx = int(value)
	if idx >= 0 and idx < opts.size():
		answer_label.text = "You picked: " + opts[idx]

func _on_TextureButton_pressed():
	if not dia_active:
		return
	var entry = dialogue[current_dialogue_id]
	var opts = entry.get("answers", [])
	var selected = int(slider.value)
	var correct = int(entry.get("correct", -1))

	if correct < 0 or correct >= opts.size():
		answer_label.text = "Bad 'correct' index: %d" % correct
	elif selected == correct:
		answer_label.text = "Correct!"
		var player = get_tree().get_current_scene().get_node("Player")
		if player:
			player.addScore()
			player.addBrain()
	else:
		answer_label.text = "Incorrect! Correct was: " + opts[correct]
		var player = get_tree().get_current_scene().get_node("Player")
		if player:
			player.removeScore()
			player.removeBrain()

	await get_tree().create_timer(2.0).timeout
	_next_script()
