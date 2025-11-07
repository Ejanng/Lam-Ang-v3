extends Control

# Chapter Scene - Displays story content and educational material
# Shows the narrative of each chapter with educational points

@onready var title_label = $VBoxContainer/TitleLabel
@onready var content_text = $VBoxContainer/ScrollContainer/ContentLabel
@onready var educational_points = $VBoxContainer/EducationalPoints
@onready var next_button = $VBoxContainer/NextButton
@onready var quiz_button = $VBoxContainer/QuizButton

var current_chapter_data: Dictionary

func _ready():
	next_button.pressed.connect(_on_next_pressed)
	quiz_button.pressed.connect(_on_quiz_pressed)
	load_chapter()

func load_chapter():
	if not GameManager:
		return
	
	var chapters = GameManager.story_data.get("story_chapters", [])
	if GameManager.current_chapter < chapters.size():
		current_chapter_data = chapters[GameManager.current_chapter]
		display_chapter()

func display_chapter():
	if title_label:
		title_label.text = current_chapter_data.get("title", "Chapter")
	
	if content_text:
		content_text.text = current_chapter_data.get("content", "")
	
	if educational_points:
		var points = current_chapter_data.get("educational_points", [])
		var points_text = "Educational Points:\n\n"
		for i in range(points.size()):
			points_text += "• " + points[i] + "\n"
		educational_points.text = points_text

func _on_next_pressed():
	# Complete chapter and move to next
	if GameManager:
		GameManager.complete_chapter(current_chapter_data["id"])
	get_tree().change_scene_to_file("res://scenes/chapter_select.tscn")

func _on_quiz_pressed():
	# Go to quiz scene for this chapter
	get_tree().change_scene_to_file("res://scenes/quiz_scene.tscn")
