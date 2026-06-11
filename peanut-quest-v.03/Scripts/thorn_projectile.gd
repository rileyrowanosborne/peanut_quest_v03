extends Area2D

var direction : Vector2 = Vector2.ZERO

@export var speed : float = 5.0

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var sprite_2d: Sprite2D = $Sprite2D




func _physics_process(delta: float) -> void:
	global_position += speed * direction
	
	if ray_cast_right.is_colliding() and direction.x == 1:
		queue_free()
		
	if ray_cast_left.is_colliding() and direction.x == -1:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(global_position)


func sprite_update():
	if direction.x == -1:
		sprite_2d.flip_h = true
	if direction.x == 1:
		sprite_2d.flip_h = false
