extends Node2D

@export var attack_range: float = 10.0
@export var make_sub_forks: bool = true
@export var fork_count: int = 1
@export var fork_offset = 300
@export var length_offset = 1

var lighting: PackedScene = preload("res://Nodes/Lighting.tscn")
var diff: Vector2
var sub_fork_count: int = 0
var sub_fork_size: float = 128
var forks: Array = []
var normal: Vector2
var target: Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Shoot"):
		create_lighting()
	
func create_lighting() -> void:
	forks.clear()
	for fork in range(0, fork_count):
		var lighting_instance: Line2D = lighting.instantiate()
		target = find_target()
		diff = target - global_position
		if make_sub_forks:
			sub_fork_count = diff.length() / 40
			sub_fork_size = diff.length() / 5
	
		normal = Vector2(diff.y, -diff.x).normalized()
		lighting_instance.create(global_position, target, diff)
		lighting_instance.sway_points(normal)
		add_child(lighting_instance)
		await get_tree().process_frame
		# lighting_instance.ap.play("Fade")
		forks.append(lighting_instance)
		if sub_fork_count > 0:
			for sub_fork in range(0, sub_fork_count):
				var picked_fork: Line2D = forks[randi_range(0, forks.size() - 1)]
				sub_forkify(normal, picked_fork.get_point_position(randi_range(0, picked_fork.get_point_count() - 1)))

func sub_forkify(normal: Vector2, point: Vector2) -> void:
	var lighting_instance: Line2D = lighting.instantiate()
	var sub_target: Vector2 = (point + normal * randi_range(-sub_fork_size, sub_fork_size)) + (target / 4) * randf()
	var sub_diff_to = sub_target - point
	var sub_normal: Vector2 = Vector2(sub_diff_to.y, -sub_diff_to.x).normalized()
	lighting_instance.create(point, sub_target, sub_diff_to)
	lighting_instance.sway_points(sub_normal)
	add_child(lighting_instance)
	await get_tree().process_frame
	# lighting_instance.ap.play("Fade")

	
func find_target() -> Vector2:
	print("Mouse: [", get_global_mouse_position().x, ",", get_global_mouse_position().y, "]")
	print("Pos: [", global_position.x, ",", global_position.y, "]")
	var dir = (get_global_mouse_position() - global_position).normalized()
	return global_position + dir * attack_range
