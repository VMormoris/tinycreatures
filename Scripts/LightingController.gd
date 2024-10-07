extends Line2D


@export var divider: float = 10
@export var sway: float = 3.0

@onready var ap: AnimationPlayer = $AnimationPlayer

func _physics_process(delta):
	var space_state = get_world_2d().direct_space_state
	# use global coordinates, not local to node
	var iterations: int = get_point_count() - 1
	for idx in range(0, iterations):
		var curr: Vector2 = to_global(get_point_position(idx))
		var next: Vector2 = to_global(get_point_position(idx + 1))
		var query = PhysicsRayQueryParameters2D.create(curr, next)
		query.collide_with_areas = true
		var result = space_state.intersect_ray(query)
		if result.has("collider"):
			if result.collider.get_meta("self") != null:
				result.collider.get_meta("self").HP -= 1

func create(start: Vector2, end: Vector2, diff: Vector2) -> void:
	add_point(start)
	add_point(end)
	
	var dist = diff.length()
	var segments: int = dist / divider
	var noice: Array[float] = []
	for _i in range(0, segments):
		noice.append(randf())
	noice.sort()
	
	var idx: int = 1
	var start_point = start
	for offset in noice:
		var next = start + offset * diff
		start_point = next
		add_point(next, idx)
		idx += 1
	
func sway_points(normal: Vector2) -> void:
	var count: int = get_point_count() - 1
	for idx in count:
		if idx == 0 or idx == count:
			continue
		
		var offset = ((get_point_position(idx) + get_point_position(idx - 1)) / 2) + normal * randf_range(-sway, sway)
		set_point_position(idx, offset)

func _on_timer_timeout() -> void:
	queue_free()
