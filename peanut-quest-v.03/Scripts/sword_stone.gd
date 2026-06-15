extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D



var in_range : bool = false


func _ready() -> void:
	GlobalSignalBus.connect("knight_deactivate", sword_deactivate)
	



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = true
		cpu_particles_2d.emitting = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = false
		cpu_particles_2d.emitting = false

func sword_deactivate():
	animated_sprite_2d.play("Idle")


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("interact") and in_range and not GameState.knight_is_active and GameState.player_is_shelled:
		animated_sprite_2d.play("SwordPull")
		
		
		await get_tree().create_timer(1.05).timeout
		GlobalSignalBus.emit_signal("knight_activate")
		GameState.current_health = 3
		GameState.knight_is_active = true
		GlobalSignalBus.emit_signal("health_check")
