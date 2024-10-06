extends Node2D

@onready var player: PlayerController = $".."
const BASE_PIVOT_Y: float = 11
const FLIP_BASE_PIVOT_Y: float = -13

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fake_animation()

func fake_animation() -> void:
	pass
	if player.velocity == Vector2.ZERO:
		fake_idle_animation()
	else:
		fake_running_animation()

func fake_idle_animation() -> void:
	position.y = FLIP_BASE_PIVOT_Y if player.sr.flip_v else BASE_PIVOT_Y
	match player.sr.frame:
		1, 4:
			position.y += 1 if player.sr.flip_v else -1
		2, 3:
			position.y += 2 if player.sr.flip_v else -2

func fake_running_animation() -> void:
	position.y = FLIP_BASE_PIVOT_Y if player.sr.flip_v else BASE_PIVOT_Y
