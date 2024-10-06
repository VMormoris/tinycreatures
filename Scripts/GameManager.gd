extends Node2D

@export var slime_scene: PackedScene
@export var enemies: int = 50
@export var range: int = 200

@onready var player: CharacterBody2D = %Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_slime_timer_timeout() -> void:
	for i in enemies:
		var slime = slime_scene.instantiate()
		var radians = 2 * PI / enemies * i
		
		var vertical = sin(radians)
		vertical *= randf_range(1.1,1.5)
		var horizontal = cos(radians)
		horizontal *= randf_range(1.1,1.5)
		var spawndir = Vector2(horizontal, vertical)
		
		var spawnpos = player.position + spawndir * range
		#print(spawnpos)
		
		slime.position = spawnpos
		slime.player = player
		add_child(slime)
