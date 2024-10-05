extends Area2D

const g: float = 50.0

@export var SPEED: float = 60.0
@export var JUMP_VELOCIY: float = -10.0

@onready var sr: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = %Player
var velocityY: float = 0.0
var touching_ground: bool = true
var ableToMove: bool = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(ableToMove):
		moveHorizontally(delta)
		moveVertically(delta)
	else:
		moveToPlayer(delta)
		ableToMove = true
	
func moveHorizontally(delta: float) -> void:
	if (sr.frame > 1):
		position.x += SPEED * delta
		if touching_ground:
			velocityY = JUMP_VELOCIY
			touching_ground = false
	elif (sr.frame <= 1):
		touching_ground = true
		velocityY = 0.0
	
func moveVertically(delta: float) -> void:
	if not touching_ground:
		position.y += velocityY * delta + 0.5 * g * delta * delta
		velocityY += g * delta

func moveToPlayer(delta: float) -> void:
	print("Elo")
	position = player.position
	#position = position.direction_tosd(player.posistion) * SPEED * delta
	if(position == player.position):
		queue_free()

func _on_player_capture() -> void:
	ableToMove = false
