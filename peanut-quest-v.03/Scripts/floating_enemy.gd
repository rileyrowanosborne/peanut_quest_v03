extends CharacterBody2D


@onready var blood_spurt: Node2D = $BloodSpurt
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var absorb_particle_effect: CPUParticles2D = $AbsorbParticleEffect



@export var speed : float = 10.0
@export var blood_spurt_scene: PackedScene

var in_range : bool = false

var current_dir : Vector2

var chase_player: bool = false

var knockback_velocity : Vector2 = Vector2.ZERO

func _ready() -> void:
	add_to_group("enemy")
	current_dir = Vector2(randi_range(-1,1), randi_range(-1,1)).normalized()
	await get_tree().create_timer(3).timeout
	change_direction()


func _physics_process(delta: float) -> void:
	
	var movement_velocity = current_dir * speed
	
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 500 * delta)
	
	velocity = movement_velocity + knockback_velocity
	
	move_and_slide()

func _process(delta: float) -> void:
	if in_range:
		set_animation("InRange")
	else:
		set_animation("OutRange")
	
	if chase_player:
		absorb_particle_effect.global_position = GameState.player_location


func change_direction():
	current_dir = Vector2(randi_range(-1,1), randi_range(-1,1)).normalized()
	
	await get_tree().create_timer(3).timeout
	change_direction()



func take_damage(attack_dir : Vector2):
	
	
	var knockback_dir : Vector2 = (global_position - attack_dir).normalized()
	
	owner.current_health -= 1
	
	knockback_velocity = knockback_dir * 200
	
	
	if owner.current_health <= 0:
		if blood_spurt.has_method("take_damage"):
			blood_spurt.take_damage()
		spawn_blood_spurt()
		animated_sprite_2d.hide()
		if owner.has_method("die"):
			chase_player = true
			absorb_particle_effect.emitting = true
			owner.die()
		else:
			print("missing die function on emeny owner - message sent from floating enemy script")
			owner.queue_free()
	else:
		if blood_spurt.has_method("take_damage"):
			blood_spurt.take_damage()


func spawn_blood_spurt():
	if blood_spurt_scene:
		var spurt_instance = blood_spurt_scene.instantiate()
		get_tree().current_scene.add_child(spurt_instance)
		spurt_instance.global_position = global_position

func set_animation(anim : String):
	if animated_sprite_2d.animation != anim:
		animated_sprite_2d.play(anim)
