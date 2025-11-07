extends Control

# Dialogue System for NPC interactions
# Handles conversation display and choices

signal dialogue_finished

@onready var dialogue_panel = $DialoguePanel
@onready var speaker_name = $DialoguePanel/VBoxContainer/SpeakerName
@onready var dialogue_text = $DialoguePanel/VBoxContainer/DialogueText
@onready var continue_button = $DialoguePanel/VBoxContainer/ContinueButton
@onready var choices_container = $DialoguePanel/VBoxContainer/ChoicesContainer

var current_dialogue: Dictionary = {}
var dialogue_queue: Array = []
var current_index: int = 0

func _ready():
	hide_dialogue()
	if continue_button:
		continue_button.pressed.connect(_on_continue_pressed)

func show_dialogue(dialogue_data: Dictionary):
	current_dialogue = dialogue_data
	dialogue_queue = dialogue_data.get("lines", [])
	current_index = 0
	
	show()
	dialogue_panel.show()
	display_current_line()

func display_current_line():
	if current_index >= dialogue_queue.size():
		end_dialogue()
		return
	
	var line = dialogue_queue[current_index]
	
	if speaker_name:
		speaker_name.text = line.get("speaker", "???")
	
	if dialogue_text:
		dialogue_text.text = line.get("text", "")
	
	# Check if this line has choices
	if line.has("choices"):
		continue_button.hide()
		show_choices(line["choices"])
	else:
		continue_button.show()
		hide_choices()

func show_choices(choices: Array):
	clear_choices()
	
	for i in range(choices.size()):
		var choice_button = Button.new()
		choice_button.text = choices[i].get("text", "Choice " + str(i + 1))
		choice_button.custom_minimum_size = Vector2(400, 40)
		choice_button.pressed.connect(_on_choice_selected.bind(i, choices[i]))
		choices_container.add_child(choice_button)

func hide_choices():
	clear_choices()

func clear_choices():
	for child in choices_container.get_children():
		child.queue_free()

func _on_continue_pressed():
	current_index += 1
	display_current_line()

func _on_choice_selected(index: int, choice_data: Dictionary):
	# Handle choice consequences
	if choice_data.has("consequence"):
		handle_consequence(choice_data["consequence"])
	
	# Move to next dialogue or specific line
	if choice_data.has("next_line"):
		current_index = choice_data["next_line"]
	else:
		current_index += 1
	
	display_current_line()

func handle_consequence(consequence: Dictionary):
	# Handle various consequences of player choices
	if consequence.has("add_item"):
		if GameManager:
			GameManager.add_to_inventory(consequence["add_item"])
	
	if consequence.has("experience"):
		if GameManager:
			GameManager.player_stats["experience"] += consequence["experience"]

func end_dialogue():
	hide_dialogue()
	dialogue_finished.emit()

func hide_dialogue():
	hide()
	if dialogue_panel:
		dialogue_panel.hide()
	clear_choices()

# Example dialogue data structure:
# {
#   "lines": [
#     {
#       "speaker": "Namongan",
#       "text": "Welcome, my son. Have you completed your quest?",
#       "choices": [
#         {
#           "text": "Yes, mother. I have avenged father.",
#           "consequence": {"experience": 50},
#           "next_line": 1
#         },
#         {
#           "text": "Not yet, but I will soon.",
#           "next_line": 2
#         }
#       ]
#     },
#     {
#       "speaker": "Namongan",
#       "text": "I am proud of you, Lam-Ang."
#     }
#   ]
# }
