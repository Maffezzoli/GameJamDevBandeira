extends Sprite2D
@export var loading_screen : PackedScene
@export var new_scene_path : String
@export var player_pos : Vector2
var shader_material: ShaderMaterial
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
	shader_material.set_shader_parameter("width", 2.0)
	shader_material.set_shader_parameter('outline_color', Color(1.0, 1.0, 1.0, 1.0))
func action():
	Global.current_scene = new_scene_path
	Global.player_pos = player_pos
	get_tree().change_scene_to_packed(loading_screen)
