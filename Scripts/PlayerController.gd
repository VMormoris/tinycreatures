extends CharacterBody2D

signal capture

const SPEED = 300.0
var succ = false


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	look_at(get_global_mouse_position())
	var direction := Input.get_vector("Left","Right","Up","Down")
	velocity = direction * SPEED
	Shoot()
	move_and_slide()

func Shoot() -> void:
	if(Input.is_action_pressed("Shoot") && succ):
		capture.emit()

func _on_area_2d_area_entered(area: Area2D) -> void:
	succ = true
