extends Area2D

const g: float = 50.0

@export var SPEED: float = 60.0
@export var JUMP_VELOCIY: float = -10.0

@onready var sr: AnimatedSprite2D = $AnimatedSprite2D
var velocityY: float = 0.0
var touching_ground: bool = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	moveHorizontally(delta)
	moveVertically(delta)
	
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
