extends CharacterBody2D

# NPC Base Script
# Template for non-player characters in the game

@export var npc_name: String = "Villager"
@export var npc_dialogue: Dictionary = {}
@export var is_quest_giver: bool = false
@export var quest_id: String = ""

@onready var sprite: Sprite2D = $Sprite2D if has_node("Sprite2D") else null
@onready var interaction_area: Area2D = $InteractionArea if has_node("InteractionArea") else null

var is_player_nearby: bool = false

signal npc_interacted(npc)

func _ready():
	if interaction_area:
		interaction_area.body_entered.connect(_on_body_entered)
		interaction_area.body_exited.connect(_on_body_exited)
	
	# Set default dialogue if none provided
	if npc_dialogue.is_empty():
		npc_dialogue = get_default_dialogue()

func _on_body_entered(body):
	if body.name == "Player":
		is_player_nearby = true
		show_interaction_prompt()

func _on_body_exited(body):
	if body.name == "Player":
		is_player_nearby = false
		hide_interaction_prompt()

func interact():
	npc_interacted.emit(self)
	# Dialogue system would handle this
	print(npc_name + " says: ", npc_dialogue)

func get_default_dialogue() -> Dictionary:
	return {
		"lines": [
			{
				"speaker": npc_name,
				"text": "Greetings, traveler! Have you heard the tale of Lam-Ang?"
			}
		]
	}

func get_dialogue() -> Dictionary:
	return npc_dialogue

func show_interaction_prompt():
	# Could show a UI prompt above the NPC
	pass

func hide_interaction_prompt():
	# Hide the UI prompt
	pass

# Example NPC dialogue for specific characters from the epic:

static func get_namongan_dialogue() -> Dictionary:
	return {
		"lines": [
			{
				"speaker": "Namongan",
				"text": "My son Lam-Ang, you have grown so strong. Your father would be proud."
			},
			{
				"speaker": "Namongan",
				"text": "Remember, strength comes not just from power, but from wisdom and compassion."
			}
		]
	}

static func get_ines_dialogue() -> Dictionary:
	return {
		"lines": [
			{
				"speaker": "Ines Kannoyan",
				"text": "Lam-Ang, your deeds are legendary throughout the land."
			},
			{
				"speaker": "Ines Kannoyan",
				"text": "But tell me, what lies in your heart?"
			}
		]
	}

static func get_villager_dialogue() -> Dictionary:
	return {
		"lines": [
			{
				"speaker": "Villager",
				"text": "Have you heard? The great Lam-Ang defeated the Igorot warriors!"
			},
			{
				"speaker": "Villager",
				"text": "His rooster's crow can shake the very earth!"
			}
		]
	}
