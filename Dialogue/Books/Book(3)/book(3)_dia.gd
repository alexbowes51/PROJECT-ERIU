extends Control

@export_file("*.json") var book_3_file
@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var rich_text_label_2: RichTextLabel = $RichTextLabel2


var pages: Array = []

func _ready() -> void:
	pages = _load_dialogue()
	visible = false

	if pages.size() > 0:
		for page_dict in pages:
			for key in page_dict.keys():
				match key:
					"Page_1":
						rich_text_label.text = page_dict[key]
					"Page_2":
						rich_text_label_2.text = page_dict[key]

func _load_dialogue() -> Array:
	var file = FileAccess.open(book_3_file, FileAccess.READ)
	if not file:
		push_error("Couldn’t open JSON: " + str(book_3_file))
		return []
	var content = file.get_as_text()
	var parsed = JSON.parse_string(content)
	if typeof(parsed) != TYPE_ARRAY:
		push_error("Dialogue JSON must be an Array, got: %s" % typeof(parsed))
		return []
	return parsed

func _process(_delta: float) -> void:
	visible = WorldManager.reading_book_3

	if WorldManager.reading_book_3 and Input.is_action_just_pressed("chat"):
		WorldManager.reading_book_3 = false
