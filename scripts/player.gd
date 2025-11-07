extends CharacterBody2D

# Player Controller for Lam-Ang
# Handles movement and basic interactions in the game world

@export var speed: float = 200.0
@export var acceleration: float = 800.0
@export var friction: float = 1000.0

var input_vector: Vector2 = Vector2.ZERO
var can_move: bool = true

# Animation states
enum State { IDLE, WALKING, INTERACTING }
var current_state = State.IDLE

var animated_sprite: AnimatedSprite2D = null
var interaction_area: Area2D = null
var last_direction: Vector2 = Vector2.DOWN

signal interacted_with(object)

func _ready():
	animated_sprite = get_node_or_null("AnimatedSprite2D")
	interaction_area = get_node_or_null("InteractionArea")
	
	if not animated_sprite:
		# Create a placeholder sprite if AnimatedSprite2D doesn't exist
		var sprite = Sprite2D.new()
		sprite.name = "Sprite2D"
		add_child(sprite)

func _physics_process(delta):
	if can_move:
		handle_input()
		move(delta)
	else:
		apply_friction(delta)
	
	move_and_slide()
	update_animation()

func handle_input():
	input_vector = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_down"):
		input_vector.y += 1
	if Input.is_action_pressed("move_up"):
		input_vector.y -= 1
	
	input_vector = input_vector.normalized()
	
	if Input.is_action_just_pressed("interact"):
		interact()

func move(delta):
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * speed, acceleration * delta)
		current_state = State.WALKING
		last_direction = input_vector
	else:
		apply_friction(delta)
		current_state = State.IDLE

func apply_friction(delta):
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

func interact():
	if interaction_area:
		var bodies = interaction_area.get_overlapping_bodies()
		var areas = interaction_area.get_overlapping_areas()
		
		if bodies.size() > 0:
			interacted_with.emit(bodies[0])
		elif areas.size() > 0:
			interacted_with.emit(areas[0])

func update_animation():
	if not animated_sprite:
		return
	
	match current_state:
		State.IDLE:
			if last_direction.x > 0:
				animated_sprite.play("idle_right")
			elif last_direction.x < 0:
				animated_sprite.play("idle_left")
			elif last_direction.y < 0:
				animated_sprite.play("idle_up")
			else:
				animated_sprite.play("idle_down")
		
		State.WALKING:
			if input_vector.x > 0:
				animated_sprite.play("walk_right")
			elif input_vector.x < 0:
				animated_sprite.play("walk_left")
			elif input_vector.y < 0:
				animated_sprite.play("walk_up")
			elif input_vector.y > 0:
				animated_sprite.play("walk_down")

func set_can_move(value: bool):
	can_move = value
	if not can_move:
		input_vector = Vector2.ZERO

func get_stats() -> Dictionary:
	if GameManager:
		return GameManager.get_player_stats()
	return {}

func take_damage(amount: int):
	if GameManager:
		GameManager.player_stats["health"] -= amount
		if GameManager.player_stats["health"] <= 0:
			die()

func heal(amount: int):
	if GameManager:
		GameManager.player_stats["health"] = min(
			GameManager.player_stats["health"] + amount,
			GameManager.player_stats["max_health"]
		)

func die():
	print("Lam-Ang has fallen!")
	# Handle death - respawn or game over
	can_move = false
	# Could trigger a game over scene or respawn logic
