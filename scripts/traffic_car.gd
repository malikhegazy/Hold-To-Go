extends Node3D

var random_car: int
var speed: float

func _ready() -> void:
	$Car.position.z = randi_range(-40, 40)
	
	car_starting()

func car_starting():
	random_car = randi_range(0, 2)
	
	speed = randi_range(15, 30)
	
	hide()
	match random_car:
		0:
			$Car/DummyCar.show()
			$Car/DummyCar.process_mode = Node.PROCESS_MODE_INHERIT
			$Car/DummyCar2.hide()
			$Car/DummyCar2.process_mode = Node.PROCESS_MODE_DISABLED
			$Car/DummyCar3.hide()
			$Car/DummyCar3.process_mode = Node.PROCESS_MODE_DISABLED
			$Car/Engine.stream = preload("res://audio/vehicles/engines/1.wav")
		1:
			$Car/DummyCar.hide()
			$Car/DummyCar.process_mode = Node.PROCESS_MODE_DISABLED
			$Car/DummyCar2.show()
			$Car/DummyCar2.process_mode = Node.PROCESS_MODE_INHERIT
			$Car/DummyCar3.hide()
			$Car/DummyCar3.process_mode = Node.PROCESS_MODE_DISABLED
			$Car/Engine.stream = preload("res://audio/vehicles/engines/2.wav")
		2:
			$Car/DummyCar.hide()
			$Car/DummyCar.process_mode = Node.PROCESS_MODE_DISABLED
			$Car/DummyCar2.hide()
			$Car/DummyCar2.process_mode = Node.PROCESS_MODE_DISABLED
			$Car/DummyCar3.show()
			$Car/DummyCar3.process_mode = Node.PROCESS_MODE_INHERIT
			$Car/Engine.stream = preload("res://audio/vehicles/engines/2.wav")
	
	$Car/Engine.play()
	await get_tree().create_timer(0.1).timeout
	show()

func _physics_process(delta: float) -> void:
	$Car.position.z -= speed * delta / 3.0
	if $Car.position.z < -40:
		$Car.position.z = 40
		car_starting()
	
	$Car/Engine.pitch_scale = speed * 0.06
	
	$Car/DummyCar/Wheel.rotate_x(speed / -100)
	$Car/DummyCar/Wheel2.rotate_x(speed / -100)
	$Car/DummyCar/Wheel3.rotate_x(speed / -100)
	$Car/DummyCar/Wheel4.rotate_x(speed / -100)
	
	$Car/DummyCar2/Wheel.rotate_x(speed / -100)
	$Car/DummyCar2/Wheel2.rotate_x(speed / -100)
	$Car/DummyCar2/Wheel3.rotate_x(speed / -100)
	$Car/DummyCar2/Wheel4.rotate_x(speed / -100)
	
	$Car/DummyCar3/Wheel.rotate_x(speed / -100)
	$Car/DummyCar3/Wheel2.rotate_x(speed / -100)
	$Car/DummyCar3/Wheel3.rotate_x(speed / -100)
	$Car/DummyCar3/Wheel4.rotate_x(speed / -100)

func hit_player(body: Node3D) -> void:
	if body.name == "Player":
		body.hit_interact()
		$Car/CollisionSound.play()

func _on_honk_area_body_entered(body: Node3D) -> void:
	$Car/Honk.play()
