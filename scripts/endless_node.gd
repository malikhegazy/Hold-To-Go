extends Node3D

@onready var player: CharacterBody3D = $"../Player"

var tracks: PackedScene
var random_tracks: int
var tracks_position: float
var tracks_positive: float

@onready var track_1 = preload("res://nodes/track.tscn")
var track_1_position: float = 10.0

@onready var track_2 = preload("res://nodes/track_2.tscn")
var track_2_position: float = 6.0

@onready var track_3 = preload("res://nodes/track_3.tscn")
var track_3_position: float = 5.5

@onready var track_4 = preload("res://nodes/track_4.tscn")
var track_4_position: float = 6.0

func _physics_process(delta: float):
	if player.position.z <= tracks_positive + 30:
		random_tracks = randi_range(0, 3)
		spawn_chunk()

func spawn_chunk() -> void:
	match random_tracks:
		0:
			tracks = track_1
			tracks_position = track_1_position
		1:
			tracks = track_2
			tracks_position = track_2_position
		2:
			tracks = track_3
			tracks_position = track_3_position
		3:
			tracks = track_4
			tracks_position = track_4_position
		
	tracks_positive -= tracks_position
	spawn_tracks(Vector3(0, 0, tracks_positive))

func spawn_tracks(pos: Vector3) -> void:
	var instance = tracks.instantiate()
	instance.position = pos
	add_child(instance)
