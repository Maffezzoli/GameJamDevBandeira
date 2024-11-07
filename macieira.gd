extends StaticBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var timer: Timer = $Timer
@onready var maca_item = preload("res://Itens/maca.tscn")
@onready var maca_arvore: Sprite2D = $MacaArvore
@onready var options = preload("res://action_options.tscn")

var shader_material: ShaderMaterial

func _ready():
	# Carrega o shader existente
	if Global.progressao['maca_coletada'] == true:
		maca_arvore.hide()
	var shader = load("res://outlineShader.gdshader")
	shader_material = ShaderMaterial.new()
	shader_material.shader = shader

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		# Aplica o shader material ao sprite
		Global.interacao.append(self)
		sprite_2d.material = shader_material
		shader_material.set_shader_parameter("width", 4.0)
		shader_material.set_shader_parameter('outline_color', Color(1.0, 1.0, 1.0, 1.0))

func _on_area_2d_body_exited(body: Node2D) -> void:
	print("Body exited:", body)
	if body is CharacterBody2D:
		# Remove o shader material do sprite (ou defina o width para 0)
		if self in Global.interacao:
			Global.interacao.erase(self)
		sprite_2d.material = null
func action():
	if Global.player.options_box.get_child_count() == 0:
		var inst = options.instantiate()
		inst.parent_ref = self
		inst.global_position = Global.player.marker_2d.global_position
		inst.scale = Vector2(10,10)
		Global.player.options_box.add_child(inst)
	
func action_chutar():
	if !animation_player.is_playing():
		Global.player.call("change_state", Global.player.State.KICK)
		await get_tree().create_timer(.5).timeout
		animation_player.play("action")
		if !Global.progressao['maca_coletada']:
			var inst = maca_item.instantiate()
			inst.global_position = maca_arvore.global_position
			Global.itens_container.add_child(inst)
			inst.cai_da_arvore()
			var item_id = randi() * int(1e6) + randi()
			var item_index = item_id
			inst.seta_id(item_id)
			Global.rigidBodyCarrega[item_index] = {
			"scene": maca_item,
			"position": inst.global_position,
			"current_scene": get_tree().current_scene.name,
			"id" : item_id
			}
			maca_arvore.hide()
			Global.progressao['maca_coletada'] = true
		if timer.is_stopped():
			gpu_particles_2d.emitting = true
			audio_stream_player_2d.play()
			timer.start()


func _on_timer_timeout() -> void:
	gpu_particles_2d.emitting = false
	timer.stop()
	timer.wait_time = 5
