extends CharacterBody2D

signal capture

const SPEED = 300.0
var succ = false

@onready var sr: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	select_orientation()
	# look_at(get_global_mouse_position())

	var direction := Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * SPEED
	Shoot()
	move_and_slide()

func Shoot() -> void:
	if(Input.is_action_pressed("Shoot") && succ):
		capture.emit()

func select_orientation() -> void:
	var mouse_dir = get_mouse_relative_dir()
	if mouse_dir.x < 0:
		sr.flip_h = true
	else:
		sr.flip_h = false

func get_mouse_relative_dir() -> Vector2:
	var half_size = get_viewport_rect().size * 0.5
	var mouse_pos = get_viewport().get_mouse_position()
	
	var dir = (mouse_pos - half_size).normalized() # Center of screen should be (0, 0)
	return dir

func _on_area_2d_area_entered(area: Area2D) -> void:
	succ = true
