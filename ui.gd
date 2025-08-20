# ui.gd
extends Control

signal difficulty_up(new_speed)

@onready var restart_button = $GameOverMenu/RestartButton
@onready var menu_button = $GameOverMenu/MenuButton

var score := 0
@onready var score_label = $ScoreLabel

func _ready() -> void:
	add_to_group("ui")
	restart_button.pressed.connect(_on_restart_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	reset_score()

func show_menu() -> void:
	$GameOverMenu.visible = true
	get_tree().paused = true
	process_mode = Node.PROCESS_MODE_ALWAYS

func add_score(points: int = 1) -> void:
	score += points
	score_label.text = "Score: %d" % score

	# 🔹 Every 10 points -> increase difficulty
	if score % 10 == 0:
		emit_signal("difficulty_up", score)

func reset_score() -> void:
	score = 0
	score_label.text = "Score: 0"

func _on_restart_pressed() -> void:
	reset_score()
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
