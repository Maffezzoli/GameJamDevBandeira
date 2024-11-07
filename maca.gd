extends genericItem
func _ready() -> void:
	pos = Vector2(-122,-60)
	shader_config()
	ref = preload("res://Itens/maca.tscn")
func cai_da_arvore():
	sprite_2d.texture = preload("res://Assets/Itens/maca_inv.png")
	
