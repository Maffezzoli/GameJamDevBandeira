extends building
@export var contem_chave = false
@onready var chave_tscn = preload("res://Itens/chave.tscn")
@onready var marker_2d: Marker2D = $Marker2D

func action_tronco():
	if contem_chave and !Global.progressao["chave_coletada"]:
		Global.progressao["chave_coletada"] = true
		var inst = chave_tscn.instantiate()
		inst.global_position = marker_2d.global_position
		Global.itens_container.add_child(inst)
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
			"scene": chave_tscn,
			"position": inst.global_position,
			"current_scene": get_tree().current_scene.name,
			"id" : item_id
		}
