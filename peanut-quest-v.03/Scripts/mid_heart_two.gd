extends CharacterBody2D



@onready var splosion_collision_shape: CollisionPolygon2D = $HeartSplosion/HitBox/SplosionCollisionShape
@onready var splosion_anim: AnimatedSprite2D = $HeartSplosion/SplosionAnim
@onready var attack_timer: Timer = $HeartSplosion/AttackTimer
@onready var heart_anim: AnimatedSprite2D = $HeartAnim





func _process(delta: float) -> void:
	
	if splosion_anim.frame == 8 or splosion_anim.frame == 9:
		splosion_collision_shape.disabled = false
	else:
		splosion_collision_shape.disabled = true


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity = get_gravity()
	
	
	move_and_slide()


func _on_attack_timer_timeout() -> void:
	attack()
	attack_timer.start()



func attack():
	splosion_anim.play("default")
	heart_anim.play("Beat")


func _on_splosion_anim_animation_finished() -> void:
	heart_anim.play("Idle")
