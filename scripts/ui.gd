extends CanvasLayer

var long_pressed_perms: float

func _ready() -> void:
	$SettingsMenu/SfxVolume.value = Global.sfx_volume
	$SettingsMenu/BgmVolume.value = Global.music_volume
	$SettingsMenu/ResVolume.value = Global.resolution_volume
	$SettingsMenu/ShadowCheckBox.button_pressed = Global.shadow
	$SettingsMenu/ResMode.selected = Global.resolution_mode
	$SettingsMenu/ShowFpsCheckBox.button_pressed = Global.show_fps
	
	animate_pointing_in_menu()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			pause_menu_continue_pressed()
		else:
			pause_button_pressed()
	
	$Game/FpsLabel.visible = Global.show_fps
	$Game/FpsLabel.text = str(Engine.get_frames_per_second()) + " FPS"

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("pause_menu_restart_pressed") or Input.is_action_pressed("pause_menu_exit_pressed"):
		long_pressed_perms += delta
		
		if Input.is_action_pressed("pause_menu_restart_pressed"):
			$PauseMenu/MenuCont/Restart/Button/TextureRect.offset_transform_scale = \
			Vector2(1.0 + 1 * long_pressed_perms * 0.6, 1.0 + 1 * long_pressed_perms * 0.6)
			$PauseMenu/MenuCont/Restart/Button/TextureRect.offset_transform_position = \
			Vector2(randi_range(-10, 10) * long_pressed_perms, randi_range(-10, 10) * long_pressed_perms)
			
			if long_pressed_perms > 1:
				long_pressed_perms = 0
				restart_scene()
		
		if Input.is_action_pressed("pause_menu_exit_pressed"):
			$PauseMenu/MenuCont/Exit/Button/TextureRect.offset_transform_scale = \
			Vector2(1.0 + long_pressed_perms * 0.6, 1.0 + long_pressed_perms * 0.6)
			$PauseMenu/MenuCont/Exit/Button/TextureRect.offset_transform_position = \
			Vector2(randi_range(-10, 10) * long_pressed_perms, randi_range(-10, 10) * long_pressed_perms)
			
			if long_pressed_perms > 1: get_tree().quit()
	else:
		long_pressed_perms = 0
		$PauseMenu/MenuCont/Restart/Button/TextureRect.offset_transform_scale = Vector2(1.0, 1.0)
		$PauseMenu/MenuCont/Restart/Button/TextureRect.offset_transform_position = Vector2(0.0, 0.0)
		$PauseMenu/MenuCont/Exit/Button/TextureRect.offset_transform_scale = Vector2(1.0, 1.0)
		$PauseMenu/MenuCont/Exit/Button/TextureRect.offset_transform_position = Vector2(0.0, 0.0)

# animatable
func animate_pause_menu():
	var tween = create_tween()
	$PauseMenu.show()
	$PauseMenu.modulate = Color(1, 1, 1, 0)
	tween.tween_property($PauseMenu, "modulate", Color(1, 1, 1, 1), 0.2)

func animate_settings_menu():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property($SettingsMenu, "position", Vector2(0, 0), 0.2)
	$SettingsMenu.position.x = 720
	$SettingsMenu.show()

func animate_game_over():
	$GameOver.show()
	$GameOver/Panel.offset_transform_scale = Vector2(0, 1)
	$GameOver/Panel/Score.hide()
	$GameOver/Panel/HiScore.hide()
	$GameOver/Panel/Restart.hide()
	
	var tween = create_tween()
	tween.tween_property($GameOver/Panel, "offset_transform_scale", Vector2(1, 1), 0.4)
	await get_tree().create_timer(0.4).timeout
	$GameOver/Panel/Score.show()
	await get_tree().create_timer(0.1).timeout
	$GameOver/Panel/HiScore.show()
	await get_tree().create_timer(0.1).timeout
	$GameOver/Panel/Restart.show()

func animate_pointing_in_menu():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property($Menu/Pointing, "offset_transform_scale", Vector2(0.9, 0.9), 1.0)
	tween.tween_property($Menu/Pointing, "offset_transform_scale", Vector2(1.0, 1.0), 1.0)
	await get_tree().create_timer(2.0).timeout
	animate_pointing_in_menu()

# text
func player_ui_signal(score) -> void:
	$Game/ScoreLabel.text = "Score: " + str(score) + "\nHigh Score: " + str(Global.hi_score)
	$GameOver/Panel/Score.text = "Score: " + str(score)
	$GameOver/Panel/HiScore.text = "High Score: " + str(Global.hi_score)

# buttons
func restart_scene() -> void:
	$Loading.show()
	await get_tree().create_timer(0.1).timeout
	pause_menu_continue_pressed()
	get_tree().reload_current_scene()

func pause_button_pressed() -> void:
	get_tree().paused = true
	
	$Menu.hide()
	$Game.hide()
	$SettingsMenu.hide()
	
	$Blur.show()
	animate_pause_menu()

func pause_menu_continue_pressed() -> void:
	get_tree().paused = false
	
	$Blur.hide()
	$Menu.hide()
	$PauseMenu.hide()
	$SettingsMenu.hide()
	
	$Game.show()

func pause_menu_settings_pressed() -> void:
	show_specs()
	get_tree().paused = true
	
	$Menu.hide()
	$Game.hide()
	$PauseMenu.hide()
	
	$Blur.show()
	animate_settings_menu()

func settings_menu_close_pressed() -> void:
	$SettingsMenu.hide()
	pause_button_pressed()

func exit_yes_preseed() -> void:
	get_tree().quit()

func exit_no_pressed() -> void:
	pause_button_pressed()

func _unhandled_input(event: InputEvent) -> void:
	if $Menu.visible:
		if event.is_pressed():
			pause_menu_continue_pressed()

# adjustable
func sfx_volume_value_changed(value: float) -> void:
	Global.sfx_volume = value

func bgm_volume_value_changed(value: float) -> void:
	Global.music_volume = value

func resolution_volume_value_changed(value: float) -> void:
	Global.resolution_volume = value

func shadow_check_box_toggled(toggled_on: bool) -> void:
	Global.shadow = toggled_on

func resolution_mode_item_selected(index: int) -> void:
	Global.resolution_mode = index

func show_fps_check_box_toggled(toggled_on: bool) -> void:
	Global.show_fps = toggled_on

func show_specs() -> void:
	var model_name = OS.get_model_name()
	var os_version = OS.get_name() + " " + OS.get_version_alias()
	var api_name: String
	if RenderingServer.get_current_rendering_driver_name() == "d3d12": api_name = "Direct3D 12"
	if RenderingServer.get_current_rendering_driver_name() == "vulkan": api_name = "Vulkan"
	if RenderingServer.get_current_rendering_driver_name() == "opengl3": api_name = "OpenGL 3.0"
	var cpu_name = OS.get_processor_name()
	var core_type = str(OS.get_processor_count()) + "-core"
	var gpu_name = RenderingServer.get_video_adapter_name()
	var audio_name = AudioServer.get_driver_name()
	
	$SettingsMenu/Specs.text = \
	model_name + " running " + os_version + "\n" + api_name +\
	" " + cpu_name + " " + core_type + " " + gpu_name + " " + audio_name + " audio output"
