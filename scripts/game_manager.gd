extends Node

# Game Manager - Controls overall game state and progression
# This manages the educational RPG experience for "Biag ni Lam-Ang"

# Game state
var current_chapter: int = 0
var player_progress: Dictionary = {}
var player_stats: Dictionary = {
	"health": 100,
	"max_health": 100,
	"strength": 5,
	"intelligence": 5,
	"experience": 0,
	"level": 1
}
var inventory: Array = []
var quizzes_completed: Array = []
var story_data: Dictionary = {}

# Signals
signal chapter_completed(chapter_id: String)
signal quiz_completed(chapter_id: String, score: int)
signal game_progress_updated()

func _ready():
	load_game_data()
	initialize_player()

func load_game_data():
	var file_path = "res://data/game_data.json"
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var json_string = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var error = json.parse(json_string)
		if error == OK:
			story_data = json.data
			print("Game data loaded successfully")
		else:
			print("Error parsing game data: ", json.get_error_message())
	else:
		print("Game data file not found")

func initialize_player():
	player_progress = {
		"chapters_unlocked": ["chapter_1"],
		"chapters_completed": [],
		"total_score": 0,
		"quizzes_passed": 0
	}

func get_chapter_data(chapter_id: String) -> Dictionary:
	if story_data.has("story_chapters"):
		for chapter in story_data["story_chapters"]:
			if chapter["id"] == chapter_id:
				return chapter
	return {}

func unlock_next_chapter():
	if story_data.has("story_chapters"):
		var total_chapters = story_data["story_chapters"].size()
		if current_chapter < total_chapters - 1:
			current_chapter += 1
			var next_chapter_id = story_data["story_chapters"][current_chapter]["id"]
			if not next_chapter_id in player_progress["chapters_unlocked"]:
				player_progress["chapters_unlocked"].append(next_chapter_id)
			game_progress_updated.emit()

func complete_chapter(chapter_id: String):
	if not chapter_id in player_progress["chapters_completed"]:
		player_progress["chapters_completed"].append(chapter_id)
		player_stats["experience"] += 100
		check_level_up()
		unlock_next_chapter()
		chapter_completed.emit(chapter_id)

func submit_quiz_answer(chapter_id: String, answer_index: int) -> Dictionary:
	var chapter = get_chapter_data(chapter_id)
	var result = {
		"correct": false,
		"explanation": "",
		"score": 0
	}
	
	if chapter.has("quiz"):
		var quiz = chapter["quiz"]
		result["correct"] = (answer_index == quiz["correct"])
		result["explanation"] = quiz["explanation"]
		
		if result["correct"]:
			result["score"] = 50
			player_progress["total_score"] += 50
			player_progress["quizzes_passed"] += 1
			player_stats["experience"] += 50
			
			if not chapter_id in quizzes_completed:
				quizzes_completed.append(chapter_id)
			
			check_level_up()
			quiz_completed.emit(chapter_id, result["score"])
	
	return result

func check_level_up():
	var exp_for_next_level = player_stats["level"] * 200
	if player_stats["experience"] >= exp_for_next_level:
		player_stats["level"] += 1
		player_stats["max_health"] += 20
		player_stats["health"] = player_stats["max_health"]
		player_stats["strength"] += 2
		player_stats["intelligence"] += 2
		print("Level up! Now level ", player_stats["level"])

func add_to_inventory(item_id: String):
	if not item_id in inventory:
		inventory.append(item_id)
		print("Added to inventory: ", item_id)

func get_player_stats() -> Dictionary:
	return player_stats

func get_inventory() -> Array:
	return inventory

func get_progress() -> Dictionary:
	return player_progress

func save_game():
	# Simple save system - can be expanded
	var save_data = {
		"player_stats": player_stats,
		"player_progress": player_progress,
		"inventory": inventory,
		"current_chapter": current_chapter,
		"quizzes_completed": quizzes_completed
	}
	
	var save_file = FileAccess.open("user://savegame.dat", FileAccess.WRITE)
	if save_file:
		save_file.store_var(save_data)
		save_file.close()
		print("Game saved successfully")
	else:
		print("Failed to save game")

func load_game():
	if FileAccess.file_exists("user://savegame.dat"):
		var save_file = FileAccess.open("user://savegame.dat", FileAccess.READ)
		if save_file:
			var save_data = save_file.get_var()
			save_file.close()
			
			if save_data:
				player_stats = save_data.get("player_stats", player_stats)
				player_progress = save_data.get("player_progress", player_progress)
				inventory = save_data.get("inventory", inventory)
				current_chapter = save_data.get("current_chapter", 0)
				quizzes_completed = save_data.get("quizzes_completed", [])
				print("Game loaded successfully")
				game_progress_updated.emit()
			else:
				print("Failed to load save data")
		else:
			print("Failed to open save file")
	else:
		print("No save file found")
