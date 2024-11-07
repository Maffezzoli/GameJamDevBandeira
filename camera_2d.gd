extends Camera2D

@export var acceleration: float = 500.0
@export var friction: float = 0.5

@export var player : CharacterBody2D


var velocity: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	var direction = (player.global_position - global_position).normalized()
	var distance = global_position.distance_to(player.global_position)

	# Acelera em direção ao jogador
	velocity += direction * acceleration * delta

	# Aplica fricção
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	# Limita a velocidade para que não ultrapasse a distância ao jogador
	if velocity.length() > distance:
		velocity = direction * distance

	# Move a câmera
	global_position += velocity * delta
