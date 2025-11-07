extends Control

# Chapter Select Screen
# Allows players to choose which chapter of the epic to experience

@onready var chapter_list = $ScrollContainer/VBoxContainer
@onready var back_button = $BackButton

func _ready():
	back_button.pressed.connect(_on_back_pressed)
	populate_chapters()

func populate_chapters():
	if not GameManager or not chapter_list:
		return
	
	var chapters = GameManager.story_data.get("story_chapters", [])
	var unlocked = GameManager.player_progress.get("chapters_unlocked", [])
	
	for i in range(chapters.size()):
		var chapter = chapters[i]
		var chapter_button = Button.new()
		chapter_button.text = chapter.get("title", "Chapter " + str(i + 1))
		chapter_button.custom_minimum_size = Vector2(400, 60)
		
		# Check if chapter is unlocked
		if chapter["id"] in unlocked:
			chapter_button.disabled = false
			chapter_button.pressed.connect(_on_chapter_selected.bind(chapter["id"]))
		else:
			chapter_button.disabled = true
			chapter_button.text += " (Locked)"
		
		# Add completion indicator
		if chapter["id"] in GameManager.player_progress.get("chapters_completed", []):
			chapter_button.text += " ✓"
		
		chapter_list.add_child(chapter_button)
		
		# Add description label
		var desc_label = Label.new()
		desc_label.text = chapter.get("description", "")
		desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		desc_label.custom_minimum_size = Vector2(400, 0)
		chapter_list.add_child(desc_label)
		
		# Add spacing
		var spacer = Control.new()
		spacer.custom_minimum_size = Vector2(0, 20)
		chapter_list.add_child(spacer)

func _on_chapter_selected(chapter_id: String):
	# Store selected chapter before loading the scene
	GameManager.current_chapter = get_chapter_index(chapter_id)
	# Load the selected chapter
	get_tree().change_scene_to_file("res://scenes/chapter_scene.tscn")

func get_chapter_index(chapter_id: String) -> int:
	var chapters = GameManager.story_data.get("story_chapters", [])
	for i in range(chapters.size()):
		if chapters[i]["id"] == chapter_id:
			return i
	return 0

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
