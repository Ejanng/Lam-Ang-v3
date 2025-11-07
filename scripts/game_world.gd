extends Node2D

# Game World - Exploration scene for the RPG
# This is where players can explore the world of Lam-Ang

@onready var player = $Player if has_node("Player") else null
@onready var camera = $Camera2D if has_node("Camera2D") else null
@onready var ui_layer = $UILayer if has_node("UILayer") else null

var current_location: String = "village"
var can_interact: bool = true

func _ready():
	setup_camera()
	setup_ui()
	if player:
		player.interacted_with.connect(_on_player_interacted)

func setup_camera():
	if camera and player:
		camera.position = player.position

func setup_ui():
	# Setup HUD elements
	pass

func _process(_delta):
	if camera and player:
		# Follow player with camera
		camera.position = player.position

func _on_player_interacted(object):
	if object and can_interact:
		# Handle interactions with NPCs, objects, etc.
		if object.has_method("interact"):
			object.interact()
		elif object.has_node("DialogueData"):
			show_dialogue(object)

func show_dialogue(npc):
	# Display dialogue interface
	can_interact = false
	if player:
		player.set_can_move(false)
	# Would show dialogue UI here
	print("Interacting with: ", npc.name)

func end_dialogue():
	can_interact = true
	if player:
		player.set_can_move(true)

func change_location(new_location: String):
	current_location = new_location
	# Load new area/map
	print("Moving to: ", new_location)
