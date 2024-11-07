extends CharacterBody2D

enum State { IDLE, WALK, JUMP, FALL, CATCH, KICK }
var current_state: State = State.IDLE

@export var walk_speed: float = 200.0
@export var jump_strength: float = -400.0
@export var gravity: float = 1000.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var torso: Bone2D = $Skeleton2D/Torso
@onready var animated_sprite_2d: AnimatedSprite2D = $Polygons/Head/AnimatedSprite2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var wall_detector: RayCast2D = $wallDetector
@onready var options_box: Node2D = $OptionsBox
@onready var marker_2d: Marker2D = $Marker2D

var sfx_max_vol = -15
var ground_type
var land = false
func _ready():
	Global.player = self
	set_physics_process(true)
func _physics_process(delta):
	if Global.player_anda == false:
		if !is_on_floor():
			current_state = State.FALL
		else:
			current_state = State.IDLE
	if ray_cast_2d.is_colliding():
		var collider = ray_cast_2d.get_collider()
		if collider != null:
			if collider.has_method("groundType"):
				ground_type = collider.groundType()
	if !is_on_floor():
		land = true
	elif is_on_floor() and land:
		land = false
		footStep("jump_land")
	match current_state:
		State.IDLE:
			idle_state(delta)
		State.WALK:
			walk_state(delta)
		State.JUMP:
			jump_state(delta)
		State.FALL:
			fall_state(delta)
		State.CATCH:
			catching(delta)
		State.KICK:
			kicking(delta)
	move_and_slide()
func change_state(new_state: State):
	current_state = new_state

# Estado Idle
func idle_state(delta):
	velocity.x = 0
	animation_player.play("Idle")
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		change_state(State.WALK)
	elif Input.is_action_just_pressed("ui_accept") and is_on_floor():
		change_state(State.JUMP)
	elif !is_on_floor():
		change_state(State.FALL)

# Estado Walk
func walk_state(delta):
	var direction = get_input_direction()

	if direction != 0:
		torso.scale.y = direction
		wall_detector.target_position.x = direction * 20
		if direction == 1:
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.offset.x = 0
		else:
			animated_sprite_2d.flip_h = true
			animated_sprite_2d.offset.x = -50
	if !wall_detector.is_colliding():
		animation_player.play("Walk")
	else:
		animation_player.play("Idle")
	velocity.x = direction * walk_speed
	if direction == 0:
		change_state(State.IDLE)
	elif Input.is_action_just_pressed("ui_accept") and is_on_floor():
		change_state(State.JUMP)
	elif !is_on_floor():
		change_state(State.FALL)

# Estado Jump
func jump_state(delta):
	animation_player.play("jump")
	velocity.x = 0
	await animation_player.animation_finished
	velocity.y = jump_strength
	# Após aplicar o impulso inicial, troca para o estado de queda
	
	change_state(State.FALL)

# Estado Fall
func fall_state(delta):
	velocity.y += gravity * delta
	animation_player.play("fall")
	if is_on_floor():
		change_state(State.IDLE)

	# Aplica a velocidade calculada ao CharacterBody2D
	move_and_slide()
func catching(delta):
	velocity.x = 0
	if wall_detector.target_position.x < 0:
		animation_player.play("take_item_l")
	else:
		animation_player.play("take_item")
	await animation_player.animation_finished
	change_state(State.IDLE)
func kicking(delta):
	if animation_player.current_animation != "kick":
		velocity.x = 0
		animation_player.play("kick")
		await animation_player.animation_finished
		change_state(State.IDLE)
func get_input_direction() -> float:
	var direction = 0.0
	if Input.is_action_pressed("ui_right"):
		direction += 1
	elif Input.is_action_pressed("ui_left"):
		direction -= 1
	return direction
func footStep(action):
	if ground_type != null:
		randomize()
		var footStepSound = Global.soundEffect[ground_type][action]
		var random_sound = footStepSound[randi() % footStepSound.size()]
		var audio_player = AudioStreamPlayer.new()
		add_child(audio_player)
		audio_player.stream = random_sound
		audio_player.volume_db = randf_range(sfx_max_vol-10, sfx_max_vol)
		audio_player.pitch_scale = randf_range(0.8, 2)
		audio_player.play()
		await audio_player.finished
		audio_player.queue_free()
func attack(action):
	if ground_type != null:
		randomize()
		var attackSound = Global.soundEffect["attack"][action]
		var random_sound = attackSound[randi() % attackSound.size()]
		var audio_player = AudioStreamPlayer.new()
		add_child(audio_player)
		audio_player.stream = random_sound
		audio_player.volume_db = randf_range(sfx_max_vol-5, sfx_max_vol)
		audio_player.pitch_scale = randf_range(0.8, 2)
		audio_player.play()
		await audio_player.finished
		audio_player.queue_free()
