extends Node2D

@onready var salt_absorb_particle_effect: CPUParticles2D = $SaltAbsorbParticleEffect

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


var is_on : bool = true




func _ready() -> void:
	show()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if GameState.current_salt < GameState.max_salt:
			if is_on:
				collect()
				if body.has_method("salt_collect"):
					body.salt_collect()




func collect():
	salt_absorb_particle_effect.emitting = true
	animated_sprite_2d.hide()
	GameState.current_salt += 1
	is_on = false
	GlobalSignalBus.emit_signal("salt_update")
	await get_tree().create_timer(.5).timeout
	queue_free()
	
