extends building

@onready var maca_dourada_tscn = preload("res://Itens/maca_dourada.tscn")
@onready var marker_2d: Marker2D = $Marker2D

func action_poco():
	var inst = maca_dourada_tscn.instantiate()
	inst.global_position = marker_2d.global_position
	Global.itens_container.add_child(inst)
	var impulso_vertical = Vector2(0, -200)
	var impulso_lateral = Vector2(randf_range(-100, 100), 0)
	var impulso_total = impulso_vertical + impulso_lateral
	inst.apply_impulse(Vector2.ZERO, impulso_total)
	Global.inv = {
		"texture" : null,
		"item_scene" : null,
		"item_pos" : Vector2()
	}
	Global.inv_slot.texture_rect.texture = null
	Global.inv_slot.item_scene = null
	var item_id = randi() * int(1e6) + randi()
	var item_index = item_id
	inst.seta_id(item_id)
	Global.rigidBodyCarrega[item_index] = {
		"scene": maca_dourada_tscn,
		"position": inst.global_position,
		"current_scene": get_tree().current_scene.name,
		"id" : item_id
	}
