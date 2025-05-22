extends Control

@export_file("*.json") var book_1_file
@onready var page_1_: RichTextLabel = $"Page(1)"
@onready var page_2_: RichTextLabel = $"Page(2)"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_load_dialogue()

func _load_dialogue() -> Array:
	var file = FileAccess.open(book_1_file, FileAccess.READ)
	if not file:
		push_error("Couldn’t open JSON: " + str(book_1_file))
		return []
	var content = file.get_as_text()
	var parsed  = JSON.parse_string(content)
	if typeof(parsed) != TYPE_ARRAY:
		push_error("Dialogue JSON must be an Array, got: %s" % typeof(parsed))
		return []
	return parsed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if WorldManager.reading_book_1 == true:
		visible = true
	else: 
		visible = false
		
	
	if WorldManager.reading_book_1 == true && Input.is_action_just_pressed("chat"): 
		WorldManager.reading_book_1 = false
