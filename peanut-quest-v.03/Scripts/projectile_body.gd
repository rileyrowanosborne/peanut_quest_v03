extends RigidBody2D


@export var direction : Vector2
@export var speed : float = 50

var in_range : bool

var is_deflected : bool

@onready var absorb_particle_effect: CPUParticles2D = $AbsorbParticleEffect






func _process(delta: float) -> void:
	pass
	#if in_range:
		#if Input.is_action_just_pressed("action"):
			#absorb_particle_effect.emitting = true
			#is_deflected = true
			#apply_central_impulse((global_position - GameState.player_location).normalized() * 500)


func _physics_process(delta: float) -> void:
	if not is_deflected:
		linear_velocity = direction * speed


func _on_projectile_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = true



func _on_projectile_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = false
