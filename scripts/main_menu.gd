extends Control

# Main Menu for Lam-Ang Chronicles
# Entry point for the educational RPG game

@onready var new_game_button = $VBoxContainer/NewGameButton
@onready var continue_button = $VBoxContainer/ContinueButton
@onready var about_button = $VBoxContainer/AboutButton
@onready var quit_button = $VBoxContainer/QuitButton
@onready var title_label = $TitleLabel

func _ready():
	# Connect button signals
	if new_game_button:
		new_game_button.pressed.connect(_on_new_game_pressed)
	if continue_button:
		continue_button.pressed.connect(_on_continue_pressed)
		# Disable continue button if no save exists
		continue_button.disabled = not FileAccess.file_exists("user://savegame.dat")
	if about_button:
		about_button.pressed.connect(_on_about_pressed)
	if quit_button:
		quit_button.pressed.connect(_on_quit_pressed)
	
	# Set up title
	if title_label:
		title_label.text = "Lam-Ang Chronicles"

func _on_new_game_pressed():
	# Start a new game
	get_tree().change_scene_to_file("res://scenes/story_intro.tscn")

func _on_continue_pressed():
	# Load saved game and continue
	if GameManager:
		GameManager.load_game()
	get_tree().change_scene_to_file("res://scenes/chapter_select.tscn")

func _on_about_pressed():
	# Show information about the game and the epic
	get_tree().change_scene_to_file("res://scenes/about.tscn")

func _on_quit_pressed():
	get_tree().quit()
