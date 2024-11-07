extends RigidBody2D
class_name genericItem
@export var name_ : String
@export var usable : bool
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var current_texture : Texture2D
@onready var label: Label = $Label
var options = preload("res://itens_options.tscn")
var id
var shader_material: ShaderMaterial
var ref
var pos
func _ready() -> void:
	shader_config()
func get_id():
	return id
func seta_id(id_new):
	id = id_new
func set_texture_pos(x):
	Global.inv_slot.texture_rect.position = x
func get_texture():
	return current_texture
func get_ref():
	return ref
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		Global.interacao.append(self)
		print(Global.interacao)
		shader_set()
		aparece_nome()
func aparece_nome():
	var tween_opacity = create_tween()
	tween_opacity.tween_property(label, "modulate", Color(0xffffff), .5)
func desaparece_nome():
	var tween_opacity = create_tween()
	tween_opacity.tween_property(label, "modulate", Color(0xffffff00), .5)
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		sprite_2d.material = null
		if self in Global.interacao:
			Global.interacao.erase(self)
		print(Global.interacao)
		desaparece_nome()
func shader_config():
	var shader = load("res://outlineShader.gdshader")
	shader_material = ShaderMaterial.new()
	shader_material.shader = shader
func shader_set():
	# Aplica o shader material ao sprite
	sprite_2d.material = shader_material
	shader_material.set_shader_parameter("width", 4.0)
	shader_material.set_shader_parameter('outline_color', Color(1.0, 1.0, 1.0, 1.0))
func action():
	if Global.player.options_box.get_child_count() == 0:
		var inst = options.instantiate()
		inst.parent_ref = self
		inst.global_position = Global.player.marker_2d.global_position
		inst.scale = Vector2(10,10)
		Global.player.options_box.add_child(inst)
func action_pegar():
	print(self)
	set_texture_pos(pos)
	Global.inv['item_pos'] = pos
	Global.inv_slot.call("add_item", self)
	Global.player.call("change_state", Global.player.State.CATCH)
