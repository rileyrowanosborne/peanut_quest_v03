extends Node2D


@onready var pivot: Node2D = $Pivot
@onready var laser_blast_timer: Timer = $LaserBlastTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var aiming_laser: RayCast2D = $Pivot/AimingLaser
@onready var firing_laser: RayCast2D = $Pivot/FiringLaser
@onready var firing_particles: CPUParticles2D = $FiringParticles
@onready var laser_particles: CPUParticles2D = $Pivot/FiringLaser/LaserParticles

var in_range : bool = false



func _ready() -> void:
	firing_laser.set_is_casting(false)



func _process(delta: float) -> void:
	
	var player_location : Vector2 = Vector2(GameState.player_location.x, GameState.player_location.y - 7)
	
	
	if in_range:
		
		pivot.look_at(player_location)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = true
		aiming_laser.set_is_casting(true)
		laser_blast_timer.start()
		



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = false
		aiming_laser.set_is_casting(false)
		laser_blast_timer.stop()


func _on_laser_blast_timer_timeout() -> void:
	firing_particles.emitting = true
	await get_tree().create_timer(1).timeout
	animated_sprite_2d.play("Close")
	await get_tree().create_timer(.3).timeout
	laser_particles.emitting = true
	firing_laser.set_is_casting(true)
	await get_tree().create_timer(1).timeout
	firing_laser.set_is_casting(false)
	laser_particles.emitting = false
	laser_blast_timer.start()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "Close":
		animated_sprite_2d.play("Idle")
