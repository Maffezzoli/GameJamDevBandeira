extends Panel
var item_scene
var dropping = false
@onready var texture_rect: TextureRect = $TextureRect
func _ready() -> void:
	Global.inv_slot = self
	texture_rect.position = Global.inv['item_pos']
	texture_rect.texture = Global.inv["texture"]
	item_scene = Global.inv["item_scene"]
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("drop"):
		drop_item()
func add_item(body):
	if !dropping:
		if texture_rect.texture == null:
			item_scene = body.get_ref()
			Global.inv["item_scene"] = body.get_ref()
			Global.inv["name"] = body.name_
			for item in Global.rigidBodyCarrega:
				if Global.rigidBodyCarrega[item]["id"] == body.get_id():
					Global.rigidBodyCarrega.erase(item)
			texture_rect.texture = body.get_texture()
			if body.name_ == "Chave":
				texture_rect.scale = Vector2(0.18, 0.18)
			else:
				texture_rect.scale = Vector2(0.7, 0.7)
			Global.inv["texture"] = body.get_texture()
			body.call_deferred("queue_free")
		else:
			drop_item()
			item_scene = body.get_ref()
			Global.inv["item_scene"] = body.get_ref()
			Global.inv["name"] = body.name_
			for item in Global.rigidBodyCarrega:
				if Global.rigidBodyCarrega[item]["id"] == body.get_id():
					Global.rigidBodyCarrega.erase(item)
			texture_rect.texture = body.get_texture()
			Global.inv["texture"] = body.get_texture()
			if body.name_ == "Chave":
				texture_rect.scale = Vector2(0.18, 0.18)
			else:
				texture_rect.scale = Vector2(0.7, 0.7)
			body.call_deferred("queue_free")
func drop_item():
	item_scene = Global.inv["item_scene"]
	if !texture_rect.texture == null and item_scene != null:
		dropping = true
		var inst = item_scene.instantiate()
		inst.global_position = Global.player.global_position
		Global.itens_container.add_child(inst)
		#Armazena a referencia ao item e a sua posição para carregamento posterior
		var item_id = randi() * int(1e6) + randi()
		var item_index = item_id
		inst.seta_id(item_id)
		Global.rigidBodyCarrega[item_index] = {
			"scene": item_scene,
			"position": inst.global_position,
			"current_scene": get_tree().current_scene.name,
			"id" : item_id
		}
		item_scene = null
		Global.inv["item_scene"] = null
		Global.inv["texture"] = null
		Global.inv["name"] = null
		texture_rect.texture = null
		await get_tree().create_timer(.5).timeout
		dropping = false
