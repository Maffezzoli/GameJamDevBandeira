extends item_option
func _ready() -> void:
	Global.player_anda = false
func _on_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if get_item_text(index) == "1. Pegar":
		action_1()
	elif get_item_text(index) == "2. Sair":
		self.queue_free()
		Global.player_anda = true

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("1"):
		action_1()
	elif Input.is_action_just_pressed("2"):
		self.queue_free()
		Global.player_anda = true
func action_1():
	parent_ref.action_pegar()
	Global.player_anda = true
	self.queue_free()
