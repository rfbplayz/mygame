extends CharacterBody2D

@onready var anim = $AnimatedSprite2D


const SPEED = 150.0
const JUMP_VELOCITY = 0

var goons = 0
var max_goons = 3
var is_gooning = false

func _ready():
	add_to_group("player")
	anim.play("Idle")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_timer_timeout() -> void:
	pass # Replace with function body.
	
func take_damage():

	goons += 1
	
	if goons < max_goons:
		if not is_gooning:
			play_goon_animation()
	else:
		play_death_animation()
		
func play_goon_animation():
	is_gooning = true
	anim.play("Goon")
	
	anim.animation_finished.connect(_on_goon_finished, CONNECT_ONE_SHOT)
		
		
func _on_goon_finished():
	anim.play("Idle")
	is_gooning = false
	
func play_death_animation():
	
	var spawner = get_node("../spawner")
	spawner.set_process(false)
	if spawner.has_node("Timer"):
		spawner.get_node("Timer").stop()

	var objects = get_tree().get_nodes_in_group("falling_objects")
	for obj in objects:
		obj.queue_free()	
	
	anim.play("Death")	
	anim.connect("animation_finished", Callable(self, "_on_death_animation_finished"),CONNECT_ONE_SHOT)
	

	
func _on_death_animation_finished():
	gameover()
	
func gameover():
	print("game over!")
	var ui = get_tree().current_scene.get_node("UI")
	ui.show_menu()
