extends genericItem
@export var pos_text : Vector2
func _ready() -> void:
	pos = pos_text
	shader_config()
	ref = preload("res://Itens/flor_amarela.tscn")
	