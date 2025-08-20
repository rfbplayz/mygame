# spawner.gd
extends Node2D

@export var enemy_scene: PackedScene
@export var base_fall_speed := 200
@export var fall_speed_increment := 20  # how much to increase each difficulty step
@onready var camera := get_tree().current_scene.get_node("Camera2D")  # adjust if your camera has another name


var current_fall_speed: int

func _ready() -> void:
	current_fall_speed = base_fall_speed
	
	# connect to UI's signal
	var ui = get_node("../UI")
	ui.difficulty_up.connect(_on_difficulty_up)

func _on_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	
	# Camera’s visible rect
	var cam_rect = camera.get_viewport_rect()
	var screen_width = cam_rect.size.x / camera.zoom.x
	
	# world-aligned left/right edges
	var half_width = screen_width / 2
	var x = randf_range(camera.global_position.x - half_width, camera.global_position.x + half_width)
	
	enemy.position = Vector2(x, position.y)
	enemy.fall_speed = current_fall_speed
	
	get_parent().add_child(enemy)

func _on_difficulty_up(new_score: int) -> void:
	current_fall_speed += fall_speed_increment
	print("Difficulty up! New fall speed:", current_fall_speed)
