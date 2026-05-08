extends CharacterBody2D



@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var direction_cooldown: Timer = $DirectionCooldown
@onready var direction_timer: Timer = $DirectionTimer

@onready var right_slash: AnimatedSprite2D = $Swing/RightSwing/RightSlash
@onready var left_slash: AnimatedSprite2D = $Swing/LeftSwing/LeftSlash
@onready var animation_player: AnimationPlayer = $Sword/AnimationPlayer
@onready var attack_timer: Timer = $AttackTimer
@onready var attack_cooldown: Timer = $AttackCooldown

@onready var left_hit_box: Area2D = $LeftHitBox
@onready var right_hit_box: Area2D = $RightHitBox


var speed : float = 50
var current_direction : int
@export var current_health : int = 3

enum movement_states {
	r_idle,
	l_idle,
	r_walking,
	l_walking,
	r_attacking,
	l_attacking
}

var current_state : movement_states

var last_dir : int

var is_attacking : bool


func _ready() -> void:
	add_to_group("enemy")
	current_direction = 1
	direction_cooldown.start()
	attack_timer.start()

func _process(delta: float) -> void:
	
	
	if current_direction == -1:
		last_dir = -1
	elif current_direction == 1:
		last_dir = 1
	
	
	if ray_cast_left.is_colliding():
		current_direction = 1
		
	if ray_cast_right.is_colliding():
		current_direction = -1
	
	if current_direction < 0:
		animated_sprite_2d.flip_h = true
	elif current_direction > 0:
		animated_sprite_2d.flip_h = false
	
	if is_attacking:
		if current_direction == -1:
			current_state = movement_states.l_attacking

		elif current_direction == 1:
			current_state = movement_states.r_attacking
	else:
		if current_direction == -1:
			current_state = movement_states.l_walking
			
		elif current_direction == 1:
			current_state = movement_states.r_walking
		else:
			if current_direction == 0:
				if last_dir == -1:
					current_state = movement_states.l_idle
				elif last_dir == 1:
					current_state = movement_states.r_idle


	match current_state:
		
		movement_states.l_idle:
			set_animation("Idle")
			animation_player.play("LeftIdle")

			
		movement_states.r_idle:
			set_animation("Idle")
			animation_player.play("RightIdle")

		
		movement_states.l_walking:
			set_animation("Walking")
			animation_player.play("LeftIdle")

		
		movement_states.r_walking:
			set_animation("Walking")
			animation_player.play("RightIdle")

		
		movement_states.l_attacking:
			animation_player.play("LeftAttack")
			left_slash.play("Slash")
			left_hit_box.monitoring = true

		
		movement_states.r_attacking:
			animation_player.play("RightAttack")
			right_slash.play("Slash")
			right_hit_box.monitoring = true

	
	



func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.x = speed * current_direction
	
	move_and_slide()




func set_animation(anim : String):
	if animated_sprite_2d.animation != anim:
		animated_sprite_2d.play(anim)



func _on_direction_timer_timeout() -> void:
	current_direction = randi_range(-1,1)
	direction_cooldown.start()
	


func _on_attack_timer_timeout() -> void:
	print('attacking')
	is_attacking = true
	


func _on_attack_cooldown_timeout() -> void:
	attack_timer.start()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "LeftAttack" or anim_name == "RightAttack":
		right_hit_box.monitoring = false
		left_hit_box.monitoring = false
		print('no longer attacking')
		is_attacking = false
		attack_cooldown.start()
		



func take_damage():
	velocity.y = -50
	current_health -= 1
	
	print("enemy hit!")
	
	if current_health <= 0:
		queue_free()
