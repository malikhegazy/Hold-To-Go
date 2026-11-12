extends CharacterBody3D

var score: int

signal cam_follow

@onready var user_interface = $"../UI"
signal ui_signal

@onready var anim_tree_node: AnimationTree = $Remy/AnimationTree

var current_anim: int
var anim_blend_speed: int = 2

var anim_idle_val: float
var anim_walking_val: float
var anim_faint_val: float

var game_over: bool

func _physics_process(delta: float) -> void:
	if not game_over:
		player(delta)
	else:
		velocity.z = 0
		$FootstepTimer.stop()
	
	if not is_on_floor(): velocity += get_gravity() * delta
	
	position.x = 0
	
	move_and_slide()
	
	ui_signal.emit(score)
	
	var cam_follow_position = position.z
	cam_follow.emit(cam_follow_position)
	
	handle_anim_tree(delta)
	
	score = -position.z
	if score > Global.hi_score:
		Global.hi_score = score

func player(delta: float) -> void:
	velocity.z = anim_walking_val * -1.5

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not game_over:
		if event.pressed:
			current_anim = 1
			$FootstepTimer.start()
		else:
			current_anim = 0
			$FootstepTimer.stop()

func handle_anim_tree(delta) -> void:
	update_anim_tree()
	match current_anim:
		0:
			anim_walking_val = move_toward(anim_walking_val, 0, anim_blend_speed * delta)
			anim_faint_val = move_toward(anim_faint_val, 0, anim_blend_speed * delta)
		1:
			anim_walking_val = move_toward(anim_walking_val, 1, anim_blend_speed * delta)
			anim_faint_val = move_toward(anim_faint_val, 0, anim_blend_speed * delta)
		2:
			anim_walking_val = move_toward(anim_walking_val, 0, anim_blend_speed * delta)
			anim_faint_val = move_toward(anim_faint_val, 1, 1)

func update_anim_tree() -> void:
	anim_tree_node["parameters/anim_walking/blend_amount"] = anim_walking_val
	anim_tree_node["parameters/anim_faint/blend_amount"] = anim_faint_val

func _on_footstep_timer_timeout() -> void:
	$Footstep.play()

func hit_interact() -> void:
	if not game_over:
		game_over = true
		current_anim = 2
		user_interface.animate_game_over()
