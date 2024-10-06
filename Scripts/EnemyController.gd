extends Area2D

const g: float = 50.0
enum ATTITUDE {Agressive, Passive, Scared}
@export var SPEED: float = 60.0
@export var JUMP_VELOCIY: float = -10.0
@export var PERSONALITY: ATTITUDE = ATTITUDE.Passive

@onready var sr: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = %Player

var dir: Vector2 = Vector2.ZERO
var velocity_y: float = 0.0
var touching_ground: bool = true

var ableToMove: bool = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#chase_player(delta)
	#apply_gravity(delta)
	if(!ableToMove):
		being_absorbed(delta)
	else:
		match PERSONALITY:
			ATTITUDE.Agressive:
				chase_player(delta)
			#ATTITUDE.Passive:
			#	print("Passive")
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

func being_absorbed(delta: float) -> void:
	dir = (player.position - position).normalized()
	select_orientation(dir)
	position += (SPEED/2) * delta * dir
	if position.distance_to(player.position) < 10:
		queue_free()

func _on_player_capture() -> void:
	ableToMove = false


func _on_player_release() -> void:
	ableToMove = true
