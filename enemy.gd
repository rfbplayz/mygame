# enemy.gd
extends Area2D

@export var fall_speed := 200

func _ready() -> void:
	add_to_group("falling_objects")

func _process(delta: float) -> void:
	position.y += fall_speed * delta
	
	var cam = get_tree().current_scene.get_node("Camera2D")
	var cam_rect = cam.get_viewport_rect()
	var screen_height = cam_rect.size.y / cam.zoom.y
	var bottom_y = cam.global_position.y + screen_height / 2
	
	if position.y > bottom_y:
		get_tree().call_group("ui", "add_score", 1)
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage()
		queue_free()
