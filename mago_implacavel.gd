extends CharacterBody2D

enum State { IDLE}
var current_state: State = State.IDLE

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $Polygons/Head/AnimatedSprite2D
var shader_material: ShaderMaterial
@onready var polygons: Node2D = $Polygons


var sfx_max_vol = -15
func _ready() -> void:
	shader_config()
func _physics_process(delta):
	match current_state:
		State.IDLE:
			idle_state(delta)
	move_and_slide()
func change_state(new_state: State):
	current_state = new_state

# Estado Idle
func idle_state(delta):
	animation_player.play("Idle")

func shader_config():
	var shader = load("res://outlineShader.gdshader")
	shader_material = ShaderMaterial.new()
	shader_material.shader = shader
func shader_set(parent: Node):
	# Verifica se o nó é um Polygon2D e aplica o shader material
	if parent is Polygon2D:
		parent.material = shader_material
		shader_material.set_shader_parameter("width", 4)
		shader_material.set_shader_parameter('outline_color', Color(1.0, 1.0, 1.0, 1.0))
	# Percorre todos os filhos e chama a função recursivamente
	for child in parent.get_children():
		shader_set(child)
func shader_unset(parent: Node):
	# Verifica se o nó é um Polygon2D e aplica o shader material
	if parent is Polygon2D:
		parent.material = null
	# Percorre todos os filhos e chama a função recursivamente
	for child in parent.get_children():
		shader_unset(child)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		shader_set(polygons)
		Global.interacao.append(self)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		shader_unset(polygons)
		if self in Global.interacao:
			Global.interacao.erase(self)
func action():
	if !Global.progressao["missao_mago"]:
		DialogueManager.show_dialogue_balloon(load("res://dialogue/mago_1.dialogue"), "this_is_a_node_title")
	elif Global.progressao["missao_mago"]:
		DialogueManager.show_dialogue_balloon(load("res://dialogue/mago_1.dialogue"), "Missao")
