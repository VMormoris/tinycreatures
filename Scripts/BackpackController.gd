extends Node2D

@onready var player: PlayerController = $".."
var magazine: Array[Color]
var ammo: int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	draw_backpack()
	fake_animation()

func draw_backpack() -> void:
	# "Empty" temporary
	for sprite: Sprite2D in get_children():
		sprite.visible = false
	
	# Prepare iteration forward or backward base on orientation
	var childrens = get_child_count()
	var start = childrens - 1 if player.sr.flip_v else 0
	var end = max(0, childrens - ammo - 1) if player.sr.flip_v else min(ammo, childrens)
	var it = -1 if player.sr.flip_v else 1

	# Fill backpack
	var color_idx = 0
	for i in range(start, end, it):
		var sprite: Sprite2D = get_child(i)
		sprite.visible = true
		sprite.modulate = magazine[color_idx]
		color_idx += 1
	
func fake_animation() -> void:
	if player.velocity == Vector2.ZERO:
		fake_idle_animation()
	else:
		fake_running_animation()

func fake_idle_animation() -> void:
	position.x = 0
	position.y = -9 if player.sr.flip_v else 0
	match player.sr.frame:
		1, 4:
			position.y += 1 if player.sr.flip_v else -1
		2, 3:
			position.y += 2 if player.sr.flip_v else -2

func fake_running_animation() -> void:
	# Move on y axis based on the orientation of the sprite
	position.y = -9 if player.sr.flip_v else 0
	# Move on x axis based on which frame
	position.x = 0 if player.sr.frame % 2 == 0 else 1

func add_ammo(color: Color) -> void:
	ammo += 1
	ammo = clampi(ammo, 0, 11)
	magazine.push_back(color)
	
func remove_ammo() -> void:
	ammo -= 1
	ammo = clampi(ammo, 0, 11)
	magazine.pop_front()
