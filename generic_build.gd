extends Sprite2D
class_name building
var shader_material: ShaderMaterial
@export var options : PackedScene
func _ready() -> void:
	shader_config()
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		shader_set()
		Global.interacao.append(self)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		self.material = null
		if self in Global.interacao:
			Global.interacao.erase(self)

func shader_config():
	var shader = load("res://outlineShader.gdshader")
	shader_material = ShaderMaterial.new()
	shader_material.shader = shader
func shader_set():
	# Aplica o shader material ao sprite
	self.material = shader_material
	shader_material.set_shader_parameter("width", 4.0)
	shader_material.set_shader_parameter('outline_color', Color(1.0, 1.0, 1.0, 1.0))
func action():
	if Global.player.options_box.get_child_count() == 0 and !Global.in_dialog:
		var inst = options.instantiate()
		inst.parent_ref = self
		inst.global_position = Global.player.marker_2d.global_position
		inst.scale = Vector2(10,10)
		Global.player.options_box.add_child(inst)
