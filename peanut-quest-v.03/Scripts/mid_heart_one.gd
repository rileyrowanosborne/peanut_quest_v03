extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


@onready var blood_particles: CPUParticles2D = $BloodParticles
@onready var blood_particles_2: CPUParticles2D = $BloodParticles2


var current_health : int = 10
@export var is_boss : bool = false

@export var absorb_scene : PackedScene


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


var knockback_velocity : Vector2 = Vector2.ZERO

var chase_player : bool = false


func _ready() -> void:
	add_to_group("enemy")
	current_dir = direction_options.pick_random()
	



func _physics_process(delta: float) -> void:
	
	var movement_velocity = current_dir.normalized() * speed
	
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 500 * delta)
	
	velocity = movement_velocity + knockback_velocity
	
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		current_dir = current_dir.bounce(collision.get_normal())


func take_damage(attack_dir : Vector2):
	var knockback_dir : Vector2 = (global_position - attack_dir).normalized()
	knockback_velocity = knockback_dir * 200
	current_health -= 1
	health_check()
	if get_parent().get_parent().has_method("health_check"):
		get_parent().get_parent().health_check()
	if is_boss:
		GameState.current_boss_health -= 1
		GlobalSignalBus.emit_signal("boss_health_update")
		


func health_check():
	if current_health <= 0:
		die()
	else:
		blood_particles.emitting = true
		blood_particles_2.emitting = true

func spawn_blood_spurt():
	if blood_spurt_scene:
		var spurt_instance = blood_spurt_scene.instantiate()
		get_tree().current_scene.add_child(spurt_instance)
		spurt_instance.scale = Vector2(2,2)
		spurt_instance.global_position = global_position


func die():
	animated_sprite_2d.hide()
	blood_particles.emitting = true
	blood_particles_2.emitting = true
	spawn_blood_spurt()
	spawn_absorb_particles()

	
	await get_tree().create_timer(.1).timeout
	
	
	queue_free()

func spawn_absorb_particles():
	if absorb_scene:
		var absorb_instance = absorb_scene.instantiate()
		get_tree().current_scene.add_child(absorb_instance)
		absorb_instance.global_position = global_position


var in_range : bool = false
var player_loc : Vector2

#
#func _on_area_2d_body_entered(body: Node2D) -> void:
	#if body.is_in_group("player"):
		#player_loc = body.global_position
		#in_range = true
#
#
#func _on_area_2d_body_exited(body: Node2D) -> void:
	#if body.is_in_group("player"):
		#in_range = false
#
#
#func _input(event: InputEvent) -> void:
	#if in_range:
		#if event.is_action("action"):
			#take_damage(player_loc)
