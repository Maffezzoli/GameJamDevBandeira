extends item_option
var habilita_3 = false
func _ready() -> void:
	Global.player_anda = false
	if  Global.inv["item_scene"] != null:
		var inst = Global.inv["item_scene"].instantiate()
		var nome = inst.name_
		if nome == "Maça":
			self.add_item("3. Jogar maçã")
			habilita_3 = true
func _on_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if get_item_text(index) == "1. Analisar":
		action_1()
	elif get_item_text(index) == "2. Sair":
		self.queue_free()
		Global.player_anda = true
	elif get_item_text(index) == "3. Jogar maçã" and habilita_3:
		action_3()
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("1"):
		action_1()
	elif Input.is_action_just_pressed("2"):
		self.queue_free()
		Global.player_anda = true
	elif Input.is_action_just_pressed("3") and habilita_3:
		action_3()
func action_1():
	if !Global.in_dialog:
		Global.in_dialog = true
		DialogueManager.show_dialogue_balloon(load("res://dialogue/analisar_poco.dialogue"), "this_is_a_node_title")
	self.queue_free()
func action_3():
	parent_ref.action_poco()
	self.queue_free()
	Global.player_anda = true
