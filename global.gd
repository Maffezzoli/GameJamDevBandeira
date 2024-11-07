extends Node
var player_pos = null
var progressao = {
	"cutscene_inicial" : false,
	"maca_coletada" : false,
	"chave_coletada" : false,
	"missao_mago" : false,
	"igredientes" : 0,
}
var inv = {
	"texture" : null,
	"item_scene" : null,
	"item_pos" : Vector2(),
	"name" : null
}
var soundEffect = {
	"attack" = {
		"kick" = 
		[preload("res://Assets/Audio/Ataque/DesignedPunch1.ogg"),
		preload("res://Assets/Audio/Ataque/DesignedPunch2.ogg"),
		preload("res://Assets/Audio/Ataque/DesignedPunch3.ogg"),
		preload("res://Assets/Audio/Ataque/DesignedPunch4.ogg")]
	},
	'grass' = {
		"walk" = 	[preload("res://Assets/Audio/FootSteps/GrassWalk/Footsteps_Walk_Grass_Mono_01.wav"),
		preload("res://Assets/Audio/FootSteps/GrassWalk/Footsteps_Walk_Grass_Mono_02.wav"),
		preload("res://Assets/Audio/FootSteps/GrassWalk/Footsteps_Walk_Grass_Mono_03.wav"),
		preload("res://Assets/Audio/FootSteps/GrassWalk/Footsteps_Walk_Grass_Mono_04.wav"),
		preload("res://Assets/Audio/FootSteps/GrassWalk/Footsteps_Walk_Grass_Mono_05.wav")],
		"jump_land" = 
		[preload("res://Assets/Audio/FootSteps/GrassJump/Footsteps_Grass_Jump_Land_01.wav"), 
		preload("res://Assets/Audio/FootSteps/GrassJump/Footsteps_Grass_Jump_Land_02.wav"),
		preload("res://Assets/Audio/FootSteps/GrassJump/Footsteps_Grass_Jump_Land_03.wav"),
		preload("res://Assets/Audio/FootSteps/GrassJump/Footsteps_Grass_Jump_Land_04.wav"),
		preload("res://Assets/Audio/FootSteps/GrassJump/Footsteps_Grass_Jump_Land_05.wav")],
		"jump_start" = 
		[preload("res://Assets/Audio/FootSteps/GrassJump/Footsteps_Grass_Jump_Start_01.wav"),
		preload("res://Assets/Audio/FootSteps/GrassJump/Footsteps_Grass_Jump_Start_02.wav"),
		preload("res://Assets/Audio/FootSteps/GrassJump/Footsteps_Grass_Jump_Start_03.wav"),
		preload("res://Assets/Audio/FootSteps/GrassJump/Footsteps_Grass_Jump_Start_04.wav"),
		preload("res://Assets/Audio/FootSteps/GrassJump/Footsteps_Grass_Jump_Start_05.wav")]
	},
	'rock' = {
		"walk" = 
		[preload("res://Assets/Audio/FootSteps/RockWalk/Footsteps_Rock_Walk_01.wav"),
		preload("res://Assets/Audio/FootSteps/RockWalk/Footsteps_Rock_Walk_02.wav"),
		preload("res://Assets/Audio/FootSteps/RockWalk/Footsteps_Rock_Walk_03.wav"),
		preload("res://Assets/Audio/FootSteps/RockWalk/Footsteps_Rock_Walk_04.wav"),
		preload("res://Assets/Audio/FootSteps/RockWalk/Footsteps_Rock_Walk_05.wav")],
		"jump_start" = 
		[preload("res://Assets/Audio/FootSteps/RockJump/Footsteps_Rock_Jump_Start_01.wav"),
		preload("res://Assets/Audio/FootSteps/RockJump/Footsteps_Rock_Jump_Start_02.wav"),
		preload("res://Assets/Audio/FootSteps/RockJump/Footsteps_Rock_Jump_Start_03.wav"),
		preload("res://Assets/Audio/FootSteps/RockJump/Footsteps_Rock_Jump_Start_04.wav"),
		preload("res://Assets/Audio/FootSteps/RockJump/Footsteps_Rock_Jump_Start_05.wav"),
		preload("res://Assets/Audio/FootSteps/RockJump/Footsteps_Rock_Jump_Start_06.wav")],
		"jump_land" =
		[preload("res://Assets/Audio/FootSteps/RockJump/Footsteps_Rock_Jump_Land_01.wav"),
		preload("res://Assets/Audio/FootSteps/RockJump/Footsteps_Rock_Jump_Land_02.wav"),
		preload("res://Assets/Audio/FootSteps/RockJump/Footsteps_Rock_Jump_Land_03.wav"),
		preload("res://Assets/Audio/FootSteps/RockJump/Footsteps_Rock_Jump_Land_04.wav"),
		preload("res://Assets/Audio/FootSteps/RockJump/Footsteps_Rock_Jump_Land_05.wav"),
		preload("res://Assets/Audio/FootSteps/RockJump/Footsteps_Rock_Jump_Land_06.wav")]
	} 
}
var interacao = []
var player
var inv_slot
var current_scene
var rigidBodyCarrega = {}
var itens_container
var player_anda = true
var in_dialog = false
var spawns = {
	"CenaPrincipal" : false,
	"Caverna" : false,
}
func _input(event: InputEvent) -> void:
	print(rigidBodyCarrega)
	if Input.is_action_just_pressed("interaction"):
		if interacao.size() > 0:
			var priority_item = null
			for item in interacao:
				if "RigidBody" in item.name:
					priority_item = item
			if priority_item == null:
				priority_item = interacao[interacao.size() - 1]
			if priority_item.has_method("action"):
				priority_item.call("action")
