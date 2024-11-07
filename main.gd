extends Node2D

@onready var carrega_dicionario = Global.rigidBodyCarrega
@onready var itens_container: Node2D = $ItensContainer
@export var cena : String
@onready var character: CharacterBody2D = $Character
@onready var camera_2d: Camera2D = $Character/Camera2D
@onready var positions_objs: Node2D = $PositionsObjs
@onready var tempo: Label = $CanvasLayer/tempo

var objetos_spawn = [
	preload("res://Itens/flor_roxa.tscn"),
	preload("res://Itens/flor_vermelha.tscn"),
	preload("res://Itens/flor_amarela.tscn"),
	preload("res://Itens/maca_dourada.tscn")
]

func _ready() -> void:
	tempo.text = str(Global.wait_time)
	if Global.progressao["missao_maca"]:
		inicia_timer()
	Global.cena_caminho = self
	if !Global.progressao["cutscene_inicial"]:
		DialogueManager.show_dialogue_balloon(load("res://dialogue/main.dialogue"), "this_is_a_node_title")
		Global.progressao["cutscene_inicial"] = true
	if Global.player_pos != null:
		character.global_position = Global.player_pos
	Global.itens_container = itens_container
	for itens in carrega_dicionario:
		if str(Global.rigidBodyCarrega[itens]['current_scene']) == cena:
			var inst = carrega_dicionario[itens]["scene"].instantiate()
			inst.global_position = carrega_dicionario[itens]["position"]
			inst.seta_id(carrega_dicionario[itens]["id"])
			Global.itens_container.add_child.call_deferred(inst)
	camera_2d.position_smoothing_enabled = false
	await get_tree().create_timer(.1).timeout
	camera_2d.position_smoothing_enabled = true
	if !Global.spawns[cena]:
		spawna_objetos()
		Global.spawns[cena] = true

func spawna_objetos():
	for itens in objetos_spawn:
		for child in positions_objs.get_children():
			var inst = itens.instantiate()
			if inst.name_ == child.name:
				inst.global_position = child.global_position
				Global.itens_container.add_child(inst)
				var item_id = randi() * int(1e6) + randi()
				var item_index = item_id
				inst.seta_id(item_id)
				Global.rigidBodyCarrega[item_index] = {
				"scene": itens,
				"position": inst.global_position,
				"current_scene": get_tree().current_scene.name,
				"id" : item_id
				}
func inicia_timer():
	await get_tree().create_timer(1).timeout
	Global.wait_time -= 1
	tempo.text = str(Global.wait_time)
	inicia_timer()
