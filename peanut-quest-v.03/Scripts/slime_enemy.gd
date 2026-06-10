extends CharacterBody2D


@onready var ray_cast_down_left: RayCast2D = $RayCastDownLeft
@onready var ray_cast_down_right: RayCast2D = $RayCastDownRight
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


const SPEED = 25.0
var direction : int = -1

var current_health : int = 1

func _ready() -> void:
	pass
	


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.x = direction * SPEED
	
	
	if ray_cast_down_left.is_colliding() and ray_cast_down_right.is_colliding():
		if ray_cast_left.is_colliding():
			direction = 1
			direction_change()
		elif ray_cast_right.is_colliding():
			direction = -1
			direction_change()
	else:
		if ray_cast_down_left.is_colliding() and not ray_cast_down_right.is_colliding():
			direction = -1
			direction_change()
		elif ray_cast_down_right.is_colliding() and not ray_cast_down_left.is_colliding():
			direction = 1
			direction_change()

	move_and_slide()



func direction_change():
	if direction == -1:
		animated_sprite_2d.flip_h = false
	elif direction == 1:
		animated_sprite_2d.flip_h = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(global_position)

func take_damage(attack_dir : Vector2):
	
	var knockback_dir : Vector2 = (global_position - attack_dir).normalized()
	velocity = knockback_dir * 100
	current_health -= 1
	health_check()


func health_check():
	if current_health <= 0:
		die()


func die():
	queue_free()
