extends Node

var sfx_volume: float:
	set(value):
		sfx_volume = value
		AudioServer.set_bus_volume_linear(0, sfx_volume)
		AudioServer.set_bus_mute(0, sfx_volume == 0)

var music_volume: float:
	set(value):
		music_volume = value
		AudioServer.set_bus_volume_linear(1, music_volume)
		AudioServer.set_bus_mute(1, music_volume == 0)

var resolution_volume: float:
	set(value):
		resolution_volume = value
		get_viewport().scaling_3d_scale = resolution_volume

var shadow: bool

var resolution_mode: int:
	set(value):
		resolution_mode = value
		match resolution_mode:
			0:
				get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_NEAREST
			1:
				get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_BILINEAR

var hi_score: int

var show_fps: bool

var save_path = "user://save_data.txt"

func _ready() -> void:
	load_data()
	get_save()

func get_save():
	await get_tree().create_timer(1.0).timeout
	save()
	get_save()

func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(sfx_volume)
	file.store_var(music_volume)
	file.store_var(resolution_volume)
	file.store_var(shadow)
	file.store_var(resolution_mode)
	file.store_var(hi_score)
	file.store_var(show_fps)

func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		sfx_volume = file.get_var(sfx_volume)
		music_volume = file.get_var(music_volume)
		resolution_volume = file.get_var(resolution_volume)
		shadow = file.get_var(shadow)
		resolution_mode = file.get_var(resolution_mode)
		hi_score = file.get_var(hi_score)
		show_fps = file.get_var(show_fps)
	else:
		sfx_volume = 1.0
		music_volume = 0.0
		resolution_volume = 0.5
		shadow = true
		resolution_mode = 1
		hi_score = 0
		show_fps = false
