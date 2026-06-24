extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var dust_particles: CPUParticles2D = $DustParticles
@onready var explosion_particles: CPUParticles2D = $ExplosionParticles
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D





func _ready() -> void:
	animated_sprite_2d.play("default")
	dust_particles.emitting = true
	explosion_particles.emitting = true
	
	await get_tree().create_timer(.1).timeout
	
	collision_shape_2d.disabled = true
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(global_position)


func _on_dust_particles_finished() -> void:
	queue_free()
