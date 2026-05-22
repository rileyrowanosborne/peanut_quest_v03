extends Node2D




@onready var absorb_particle_effect: CPUParticles2D = $AbsorbParticleEffect


var chase_player : bool = false

func _ready() -> void:
	absorb_particle_effect.emitting = true
	await get_tree().create_timer(.5).timeout
	chase_player = true
	


func _process(delta: float) -> void:
	if chase_player:
		absorb_particle_effect.global_position = GameState.player_location


func _on_absorb_particle_effect_finished() -> void:
	queue_free()
