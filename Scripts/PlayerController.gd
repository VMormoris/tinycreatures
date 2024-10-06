class_name PlayerController
extends CharacterBody2D

signal capture
signal release

@export var range: Area2D
const SPEED = 150.0
var dir: Vector2 = Vector2.ZERO
var succ = false
var limit_vaccum: int = 0
var hp: int = 100

@onready var sr: AnimatedSprite2D = $AnimatedSprite2D
@onready var asp: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var backpack = $Backpack

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	select_orientation()
	look_at(get_global_mouse_position())

	var direction := Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * SPEED
	select_animation()
	Shoot(delta)
	move_and_slide()

func Shoot(delta: float) -> void:
	if(Input.is_action_pressed("Shoot") && succ):
		limit_vaccum = 0
		for enemy in range.get_overlapping_areas():
			if(limit_vaccum < 5):
				absorb_enemy(enemy, delta)
				limit_vaccum += 1
		if not asp.playing:
			asp.play()
		capture.emit()
	elif(Input.is_action_just_released("Shoot")):
		limit_vaccum = 0
		asp.stop()
		release.emit()

func select_orientation() -> void:
	var mouse_dir = get_mouse_relative_dir()
	sr.flip_v = mouse_dir.x < 0

func get_mouse_relative_dir() -> Vector2:
	var half_size = get_viewport_rect().size * 0.5
	var mouse_pos = get_viewport().get_mouse_position()
	
	var dir = (mouse_pos - half_size).normalized() # Center of screen should be (0, 0)
	return dir

func _on_area_2d_area_entered(area: Area2D) -> void:
	succ = true

func absorb_enemy(enemy: Area2D, delta: float) -> void:
	dir = (enemy.position - position).normalized()
	enemy.position -= (SPEED/2) * delta * dir
	if(enemy.position.distance_to(position) < 25):
		backpack.add_ammo(enemy.sr.modulate)
		limit_vaccum -= 1
		enemy.queue_free()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if(range.get_overlapping_areas() == null):
		succ = false

func select_animation():
	if velocity == Vector2.ZERO:
		sr.play("Idle")
	else:
		sr.play("Running")


func _on_hitbox_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	hp -= 1
	print(hp)
	area.queue_free()
