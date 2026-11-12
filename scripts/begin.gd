extends CanvasLayer

func _ready() -> void:
	OS.request_permissions()
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/main.tscn")
