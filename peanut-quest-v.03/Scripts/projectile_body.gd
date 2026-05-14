extends RigidBody2D



@export var direction : Vector2
@export var speed : float = 50


func _physics_process(delta: float) -> void:
	
	linear_velocity = speed * direction
