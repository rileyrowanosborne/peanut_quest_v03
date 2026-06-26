extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var damage_timer: Timer = $DamageTimer



var speed : float = 50
var direction : Vector2 = Vector2(1,0)

var current_health : int = 2

var is_taking_damage : bool = false


func _ready() -> void:
	add_to_group("enemy")
	direction_update()

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if not is_taking_damage:
		velocity = speed * direction
		
	if ray_cast_left.is_colliding() and direction == Vector2(-1,0):
		direction = Vector2(1,0)
		direction_update()
	
	if ray_cast_right.is_colliding() and direction == Vector2(1,0):
		direction = Vector2(-1,0)
		direction_update()
	
	move_and_slide()


func direction_update():
	if direction == Vector2(-1,0):
		animated_sprite_2d.flip_h = false
	elif direction == Vector2(1,0):
		animated_sprite_2d.flip_h = true


func take_damage(attack_dir : Vector2):
		var knockback_dir : Vector2 = (global_position - attack_dir).normalized()
		
		is_taking_damage = true
		damage_timer.start()
		
		velocity = knockback_dir * 500
		animated_sprite_2d.play("Hurt")
		current_health -= 1
		health_check()

func health_check():
	if current_health <= 0:
		die()

func die():
	queue_free()


func _on_animated_sprite_2d_animation_finished() -> void:
	animated_sprite_2d.play("Idle")


func _on_damage_timer_timeout() -> void:
	is_taking_damage = false
