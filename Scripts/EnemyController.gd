extends Area2D

const g: float = 50.0

@export var SPEED: float = 60.0
@export var JUMP_VELOCIY: float = -10.0

@onready var sr: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = %Player

var dir: Vector2 = Vector2.ZERO
var velocity_y: float = 0.0
var touching_ground: bool = true

var ableToMove: bool = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	chase_player(delta)
	apply_gravity(delta)
#	if(ableToMove):
#		moveHorizontally(delta)
#		moveVertically(delta)
#	else:
#		moveToPlayer(delta)
#		ableToMove = true
	
func chase_player(delta: float) -> void:
	dir = (player.position - position).normalized()
	select_orientation(dir)
	
	if sr.frame > 1:
		position += SPEED * delta * dir
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

func moveToPlayer(delta: float) -> void:
	print("Elo")
	position = player.position
	#position = position.direction_tosd(player.posistion) * SPEED * delta
	if position == player.position:
		queue_free()

func _on_player_capture() -> void:
	ableToMove = false
