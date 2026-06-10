extends CharacterBody2D

var direction : Vector2 = Vector2.ZERO
var current_rotation : float = 0.0
var speed : float = 0.0


func _ready() -> void:
	rotation_degrees = current_rotation

	
func _physics_process(delta: float) -> void: 
	velocity = speed * direction
	
	move_and_slide()


func delete():
	queue_free()
