extends Node2D

@export var slime_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_slime_timer_timeout() -> void:
	var slime = slime_scene.instantiate()
	add_child(slime)
