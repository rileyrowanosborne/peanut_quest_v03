extends CharacterBody2D




@onready var ray_cast_down: RayCast2D = $RayCastDown
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_up: RayCast2D = $RayCastUp
@onready var ray_cast_left: RayCast2D = $RayCastLeft

@onready var ray_cast_down_2: RayCast2D = $RayCastDown2
@onready var ray_cast_right_2: RayCast2D = $RayCastRight2
@onready var ray_cast_up_2: RayCast2D = $RayCastUp2
@onready var ray_cast_left_2: RayCast2D = $RayCastLeft2






var current_health : int = 3
var current_dir : Vector2
var direction_options = [
	Vector2(1,1),
	Vector2(1,-1),
	Vector2(-1,-1),
	Vector2(-1,1)
]


@export var is_moving : bool = true
@export var speed : float = 50
@export var is_bouncing : bool = true

@export var movement_dir : Vector2 = Vector2(0,0)



var knockback_velocity : Vector2 = Vector2.ZERO

func _ready() -> void:
	if is_moving:
		if is_bouncing:
			current_dir = direction_options.pick_random()
		else:
			current_dir = movement_dir
	
	else:
		current_dir = Vector2.ZERO
	
	add_to_group("enemy")


func _physics_process(delta: float) -> void:
	
	var movement_velocity = current_dir.normalized() * speed
	
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 500 * delta)
	
	velocity = movement_velocity + knockback_velocity
	
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		current_dir = current_dir.bounce(collision.get_normal())
		
	
	
	if not is_bouncing:
		if ray_cast_down.is_colliding() or ray_cast_down_2.is_colliding():
			current_dir = Vector2(0,-1)
		
		if ray_cast_right.is_colliding() or ray_cast_right_2.is_colliding():
			current_dir = Vector2(-1,0)
			
		if ray_cast_left.is_colliding() or ray_cast_left_2.is_colliding():
			current_dir = Vector2(1,0)
		
		if ray_cast_up.is_colliding() or ray_cast_up_2.is_colliding():
			current_dir = Vector2(0,1)


func take_damage(attack_dir : Vector2):
	
	var knockback_dir : Vector2 = (global_position - attack_dir).normalized()
	knockback_velocity = knockback_dir * 100
	current_health -= 1
	health_check()





func health_check():
	if current_health <= 0:
		die()


func die():
	queue_free()
