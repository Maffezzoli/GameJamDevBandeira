extends AnimatedSprite2D

@onready var timer: Timer = $Timer

func _ready():
	# Configura o Timer com um intervalo aleatório inicial e conecta o sinal
	_set_random_timer()

func _on_timer_timeout():
	# Define a animação para "default" e inicia
	animation = "default"
	play()
	# Redefine o Timer com um intervalo aleatório após tocar a animação
	_set_random_timer()

func _set_random_timer():
	# Configura um tempo aleatório entre 1 e 10 segundos e reinicia o Timer
	timer.wait_time = randf_range(1, 10)
	timer.start()
