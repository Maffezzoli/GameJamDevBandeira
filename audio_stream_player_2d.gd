extends AudioStreamPlayer2D


# Configuração inicial para o range do pitch
@export var min_pitch: float = 0.101
@export var max_pitch: float = 2

func _ready():
	# Conecta o sinal "finished" do AudioStreamPlayer para chamar a função on_audio_finished
	# Inicia o áudio pela primeira vez
	_start_audio_with_random_pitch()

func _start_audio_with_random_pitch():
	# Define um pitch aleatório dentro do range especificado
	self.pitch_scale = randf_range(min_pitch, max_pitch)
	# Reinicia o áudio
	self.play()


func _on_finished() -> void:
	_start_audio_with_random_pitch()
