extends Control
var cena_nova
var scene_load_status = 0
var progress = [0]
@onready var label: Label = $Label

func _ready() -> void:
	cena_nova = Global.current_scene
	ResourceLoader.load_threaded_request(cena_nova)
func _process(delta: float) -> void:
	scene_load_status = ResourceLoader.load_threaded_get_status(cena_nova, progress)
	label.text = str(floor(progress[0]*100)) + "%"
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var newScene = ResourceLoader.load_threaded_get(cena_nova)
		get_tree().change_scene_to_packed(newScene)
