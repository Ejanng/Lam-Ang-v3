extends Control

# Combat System for RPG battles
# Turn-based combat inspired by classic RPGs

signal combat_ended(victory: bool)

@onready var player_health_bar = $CombatUI/PlayerPanel/HealthBar
@onready var enemy_health_bar = $CombatUI/EnemyPanel/HealthBar
@onready var player_name_label = $CombatUI/PlayerPanel/NameLabel
@onready var enemy_name_label = $CombatUI/EnemyPanel/NameLabel
@onready var action_buttons = $CombatUI/ActionButtons
@onready var combat_log = $CombatUI/CombatLog

var player_stats: Dictionary
var enemy_stats: Dictionary
var current_turn: String = "player"  # "player" or "enemy"

func _ready():
	hide()

func start_combat(enemy_data: Dictionary):
	enemy_stats = enemy_data.duplicate()
	player_stats = GameManager.get_player_stats() if GameManager else {}
	
	setup_ui()
	show()
	player_turn()

func setup_ui():
	if player_name_label:
		player_name_label.text = "Lam-Ang"
	if enemy_name_label:
		enemy_name_label.text = enemy_stats.get("name", "Enemy")
	
	update_health_bars()
	
	# Connect action buttons
	var attack_btn = action_buttons.get_node_or_null("AttackButton")
	var defend_btn = action_buttons.get_node_or_null("DefendButton")
	var special_btn = action_buttons.get_node_or_null("SpecialButton")
	var flee_btn = action_buttons.get_node_or_null("FleeButton")
	
	if attack_btn:
		attack_btn.pressed.connect(_on_attack_pressed)
	if defend_btn:
		defend_btn.pressed.connect(_on_defend_pressed)
	if special_btn:
		special_btn.pressed.connect(_on_special_pressed)
	if flee_btn:
		flee_btn.pressed.connect(_on_flee_pressed)

func update_health_bars():
	if player_health_bar:
		var max_hp = player_stats.get("max_health", 100)
		var current_hp = player_stats.get("health", 100)
		player_health_bar.value = (float(current_hp) / max_hp) * 100
	
	if enemy_health_bar:
		var max_hp = enemy_stats.get("health", 50)
		var current_hp = enemy_stats.get("current_health", max_hp)
		enemy_health_bar.value = (float(current_hp) / max_hp) * 100

func player_turn():
	current_turn = "player"
	enable_action_buttons(true)
	log_message("Your turn!")

func enemy_turn():
	current_turn = "enemy"
	enable_action_buttons(false)
	log_message(enemy_stats.get("name", "Enemy") + "'s turn!")
	
	# Simple AI - just attack
	await get_tree().create_timer(1.0).timeout
	enemy_attack()

func _on_attack_pressed():
	var damage = calculate_damage(player_stats, enemy_stats)
	enemy_stats["current_health"] = enemy_stats.get("current_health", enemy_stats["health"]) - damage
	
	log_message("Lam-Ang attacks for " + str(damage) + " damage!")
	update_health_bars()
	
	if enemy_stats["current_health"] <= 0:
		victory()
	else:
		enemy_turn()

func _on_defend_pressed():
	# Reduce damage next turn
	player_stats["defending"] = true
	log_message("Lam-Ang takes a defensive stance!")
	enemy_turn()

func _on_special_pressed():
	# Special attack using magical rooster
	var damage = calculate_damage(player_stats, enemy_stats) * 2
	enemy_stats["current_health"] = enemy_stats.get("current_health", enemy_stats["health"]) - damage
	
	log_message("Lam-Ang's rooster crows with mighty power! " + str(damage) + " damage!")
	update_health_bars()
	
	if enemy_stats["current_health"] <= 0:
		victory()
	else:
		enemy_turn()

func _on_flee_pressed():
	# Attempt to flee
	var flee_chance = randf()
	if flee_chance > 0.5:
		log_message("Fled successfully!")
		await get_tree().create_timer(1.0).timeout
		end_combat(false)
	else:
		log_message("Failed to flee!")
		enemy_turn()

func enemy_attack():
	var damage = calculate_damage(enemy_stats, player_stats)
	
	if player_stats.get("defending", false):
		damage = int(damage / 2)
		player_stats["defending"] = false
	
	player_stats["health"] = player_stats.get("health", 100) - damage
	
	log_message(enemy_stats.get("name", "Enemy") + " attacks for " + str(damage) + " damage!")
	update_health_bars()
	
	if player_stats["health"] <= 0:
		defeat()
	else:
		player_turn()

func calculate_damage(attacker: Dictionary, defender: Dictionary) -> int:
	var base_damage = attacker.get("strength", 5)
	var defense = defender.get("strength", 5) / 2
	var damage = max(1, base_damage - defense + randi() % 5)
	return int(damage)

func victory():
	log_message("Victory! The enemy has been defeated!")
	
	# Award experience
	var exp_gained = enemy_stats.get("health", 50)
	if GameManager:
		GameManager.player_stats["experience"] += exp_gained
		GameManager.check_level_up()
	
	log_message("Gained " + str(exp_gained) + " experience!")
	
	await get_tree().create_timer(2.0).timeout
	end_combat(true)

func defeat():
	log_message("Lam-Ang has fallen...")
	await get_tree().create_timer(2.0).timeout
	end_combat(false)

func end_combat(won: bool):
	hide()
	combat_ended.emit(won)

func enable_action_buttons(enabled: bool):
	if action_buttons:
		for button in action_buttons.get_children():
			if button is Button:
				button.disabled = not enabled

func log_message(message: String):
	if combat_log:
		combat_log.text += message + "\n"
	print("[Combat] " + message)
