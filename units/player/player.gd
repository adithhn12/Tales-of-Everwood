extends CharacterBody2D

signal game_over(victorious: bool)
signal update_hp_bar(hp_bar_value: bool)

enum State {
	IDLE,
	RUN,
	ATTACK,
	DEAD
}

@export_category("Stats")
@export var speed: int = 200
@export var attack_damage: int = 60
@export var hitpoints: int = 150

var state: State = State.IDLE
var move_direction: Vector2 = Vector2.ZERO
var facing_direction: Vector2 = Vector2.RIGHT
var attack_speed: float
var hitpoints_max: int

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_playback: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]


func _ready() -> void:
	hitpoints_max=hitpoints
	animation_tree.set_active(true)
	calculate_stats()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		attack()

func _physics_process(_delta: float) -> void:
	if state != State.ATTACK:
		movement_loop()


func calculate_stats() -> void:
	attack_speed = Equations.calculate_attack_speed()
	var time_factor: float = Equations.BASE_ATTACK_SPEED / attack_speed
	animation_tree.set("parameters/Attack/TimeScale/scale", time_factor)
	print("my new attack speed: ", attack_speed)


func movement_loop() -> void:
	move_direction.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	move_direction.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))

	var motion: Vector2 = move_direction.normalized() * speed

	# Update facing direction when moving
	if move_direction != Vector2.ZERO:
		# Determine whether horizontal or vertical direction has priority
		if abs(move_direction.x) > abs(move_direction.y):
			facing_direction = Vector2(sign(move_direction.x), 0)
		elif abs(move_direction.y) > abs(move_direction.x):
			facing_direction = Vector2(0, sign(move_direction.y))
		else:
			# For diagonal movement, keep the previous facing direction
			pass

	set_velocity(motion)
	move_and_slide()

	# Sprite flip during idle/run
	if state == State.IDLE or state == State.RUN:
		if facing_direction.x < 0:
			$Sprite2D.flip_h = true
		elif facing_direction.x > 0:
			$Sprite2D.flip_h = false

	if motion != Vector2.ZERO and state == State.IDLE:
		state = State.RUN
		update_animation()

	elif motion == Vector2.ZERO and state == State.RUN:
		state = State.IDLE
		update_animation()


func update_animation() -> void:
	match state:
		State.IDLE:
			animation_playback.travel("idle")

		State.RUN:
			animation_playback.travel("run")

		State.ATTACK:
			animation_playback.travel("Attack")


func attack() -> void:
	# Don't attack while already attacking
	if state == State.ATTACK:
		return

	state = State.ATTACK

	# Attack in the direction the player is facing
	var attack_dir: Vector2 = facing_direction

	# Flip sprite for horizontal attacks
	if attack_dir.x < 0:
		$Sprite2D.flip_h = true
	elif attack_dir.x > 0:
		$Sprite2D.flip_h = false

	# Send attack direction to AnimationTree BlendSpace2D
	animation_tree.set(
		"parameters/Attack/BlendSpace2D/blend_position",
		attack_dir
	)

	update_animation()

	# Wait for attack to finish
	await get_tree().create_timer(attack_speed).timeout

	if not is_inside_tree():
		return

	state = State.IDLE


func take_damage(damage_taken: int) -> void:
	hitpoints -= damage_taken
	@warning_ignore("integer_division")
	update_hp_bar.emit((hitpoints*100)/hitpoints_max)
	if hitpoints <= 0:
		death()


func death() -> void:
	game_over.emit(false)


func _on_hit_box_area_entered(area: Area2D) -> void:
	area.owner.take_damage(attack_damage)
