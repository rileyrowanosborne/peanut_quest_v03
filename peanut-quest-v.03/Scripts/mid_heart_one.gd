extends CharacterBody2D


@onready var blood_particles: CPUParticles2D = $BloodParticles
@onready var blood_particles_2: CPUParticles2D = $BloodParticles2
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


var current_health : int = 3


@export var speed : float = 50
@export var blood_spurt_scene: PackedScene

var current_dir : Vector2

var direction_options = [
	Vector2(1,1),
	Vector2(1,-1),
	Vector2(-1,-1),
	Vector2(-1,1)
]

@export var is_moving : bool = true

func _ready() -> void:
	if is_moving:
		current_dir = direction_options.pick_random()
	
	else:
		current_dir = Vector2.ZERO
	
	add_to_group("enemy")


func _physics_process(delta: float) -> void:
	
	var velocity = current_dir.normalized() * speed
	
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		current_dir = current_dir.bounce(collision.get_normal())


func take_damage(attack_dir : Vector2):
	
	var knockback_dir : Vector2 = (global_position - attack_dir).normalized()
	velocity = knockback_dir * 500
	
	
	current_health -= 1
	health_check()
	

func health_check():
	if current_health <= 0:
		animated_sprite_2d.hide()
		blood_particles.emitting = true
		blood_particles_2.emitting = true
		spawn_blood_spurt()
		await get_tree().create_timer(.1).timeout
		
		
		queue_free()
	else:
		blood_particles.emitting = true
		blood_particles_2.emitting = true

func spawn_blood_spurt():
	if blood_spurt_scene:
		var spurt_instance = blood_spurt_scene.instantiate()
		get_tree().current_scene.add_child(spurt_instance)
		spurt_instance.scale = Vector2(2,2)
		spurt_instance.global_position = global_position
