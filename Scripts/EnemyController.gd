extends Area2D

enum ATTITUDE {Agressive, Passive, Scared}

const g: float = 50.0
var COLOR_PALETTE: Array[Color] = [
	Color8(116, 246, 247),
	Color8(255, 117, 3),
	Color8(216, 115, 133),
	Color8(170, 90, 150),
]

@export var SPEED: float = 60.0
@export var JUMP_VELOCIY: float = -10.0
@export var PERSONALITY: ATTITUDE = ATTITUDE.Agressive

@onready var sr: AnimatedSprite2D = $AnimatedSprite2D
var player: CharacterBody2D = null

var dir: Vector2 = Vector2.ZERO
var velocity_y: float = 0.0
var touching_ground: bool = true

var ableToMove: bool = true
var chasing: bool = true
var color: Color

func _ready() -> void:
	if player == null:
		player = get_node("%Player")
	var idx = randi_range(0, COLOR_PALETTE.size() - 1)
	sr.modulate = COLOR_PALETTE[idx]
	var callable = Callable(self, "_on_day_night_transition")
	$"../Day_Night".connect("timeout", callable, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	chase_or_run_from_player(delta)

func chase_or_run_from_player(delta: float) -> void:
	dir = (player.position - position).normalized()
	select_orientation(dir)
	var multiplier =  1 if chasing else -1
	if sr.frame > 1:
		position += SPEED * delta * multiplier * dir
		if touching_ground:
			velocity_y = JUMP_VELOCIY
			touching_ground = false
	elif sr.frame <= 1:
		touching_ground = true	

func apply_gravity(delta: float) -> void:
	if not touching_ground:
		position.y += velocity_y * delta + 0.5 * g * delta * delta
		velocity_y += g * delta
		
func select_orientation(dir: Vector2) -> void:
	if dir.x < 0:
		sr.flip_h = true
	else:
		sr.flip_h = false

func _on_day_night_transition():
	chasing = !chasing
