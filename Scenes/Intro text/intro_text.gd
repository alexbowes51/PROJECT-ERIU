extends Control

signal dialogue_finished(index)

@export_file("*.json") var Intro_D_file

var dialogue = []
var current_dialogue_id = -1
var dia_active = false

var typing_speed = 0.03
var typing_timer = 0.0
var full_text = ""
var current_text = ""
var is_typing = false

func _ready() -> void:
	dialogue = load_dialogue()
	hide()
	$Intro.text = ""

func load_dialogue():
	var file = FileAccess.open(Intro_D_file, FileAccess.READ)
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) == TYPE_ARRAY:
		return parsed
	push_error("Failed to load dialogue")
	return []

func show_dialogue(index: int):
	if index < 0 or index >= dialogue.size():
		push_error("Invalid dialogue index: %d" % index)
		return
		
	current_dialogue_id = index
	full_text = dialogue[index]["Intro"]
	current_text = ""
	$Intro.text = ""
	typing_timer = 0.0
	is_typing = true
	show()
	dia_active = true

func _process(delta: float) -> void:
	if is_typing:
		typing_timer += delta
		if typing_timer >= typing_speed:
			typing_timer = 0.0
			if current_text.length() < full_text.length():
				current_text += full_text[current_text.length()]
				$Intro.text = current_text
			else:
				is_typing = false

func next_script():
	# if still typing, skip to full
	if is_typing:
		$Intro.text = full_text
		is_typing = false
		return

	# otherwise go to next line
	current_dialogue_id += 1
	if current_dialogue_id < dialogue.size():
		show_dialogue(current_dialogue_id)
	else:
		hide()
		dia_active = false
		emit_signal("dialogue_finished", current_dialogue_id - 1)
