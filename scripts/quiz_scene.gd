extends Control

# Quiz Scene - Educational assessment for each chapter
# Tests player's understanding of the story and cultural content

@onready var question_label = $VBoxContainer/QuestionLabel
@onready var options_container = $VBoxContainer/OptionsContainer
@onready var submit_button = $VBoxContainer/SubmitButton
@onready var result_panel = $ResultPanel
@onready var result_label = $ResultPanel/VBoxContainer/ResultLabel
@onready var explanation_label = $ResultPanel/VBoxContainer/ExplanationLabel
@onready var continue_button = $ResultPanel/VBoxContainer/ContinueButton

var current_chapter_data: Dictionary
var selected_answer: int = -1
var option_buttons: Array = []

func _ready():
	submit_button.pressed.connect(_on_submit_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	result_panel.hide()
	load_quiz()

func load_quiz():
	if not GameManager:
		return
	
	var chapters = GameManager.story_data.get("story_chapters", [])
	if GameManager.current_chapter < chapters.size():
		current_chapter_data = chapters[GameManager.current_chapter]
		display_quiz()

func display_quiz():
	var quiz = current_chapter_data.get("quiz", {})
	
	if question_label:
		question_label.text = quiz.get("question", "")
	
	if options_container:
		var options = quiz.get("options", [])
		for i in range(options.size()):
			var button = Button.new()
			button.text = options[i]
			button.toggle_mode = true
			button.custom_minimum_size = Vector2(500, 50)
			button.pressed.connect(_on_option_selected.bind(i))
			options_container.add_child(button)
			option_buttons.append(button)

func _on_option_selected(index: int):
	selected_answer = index
	# Deselect other buttons
	for i in range(option_buttons.size()):
		if i != index:
			option_buttons[i].button_pressed = false

func _on_submit_pressed():
	if selected_answer == -1:
		return
	
	if not GameManager:
		return
	
	var result = GameManager.submit_quiz_answer(current_chapter_data["id"], selected_answer)
	show_result(result)

func show_result(result: Dictionary):
	submit_button.hide()
	
	if result_label:
		if result["correct"]:
			result_label.text = "Correct! ✓\nYou earned " + str(result["score"]) + " points!"
			result_label.add_theme_color_override("font_color", Color.GREEN)
		else:
			result_label.text = "Incorrect ✗\nKeep learning!"
			result_label.add_theme_color_override("font_color", Color.RED)
	
	if explanation_label:
		explanation_label.text = result.get("explanation", "")
	
	result_panel.show()

func _on_continue_pressed():
	get_tree().change_scene_to_file("res://scenes/chapter_select.tscn")
