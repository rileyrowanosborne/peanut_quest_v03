extends CharacterBody2D


#main player nodes
@onready var peanut_anims: AnimatedSprite2D = $PeanutAnims

@onready var standing_collision_shape: CollisionShape2D = $StandingCollisionShape
@onready var sliding_collision_shape: CollisionShape2D = $SlidingCollisionShape


#timers
@onready var turn_timer: Timer = $Timers/TurnTimer
@onready var slide_timer: Timer = $"Timers/Slide Timer"
@onready var slide_cooldown_timer: Timer = $Timers/SlideCooldownTimer
@onready var coyote_timer: Timer = $Timers/CoyoteTimer
@onready var jump_buffer_timer: Timer = $Timers/JumpBufferTimer
@onready var wall_coyote_timer: Timer = $Timers/WallCoyoteTimer
@onready var wall_slide_wait_timer: Timer = $Timers/WallSlideWaitTimer
@onready var spawn_timer: Timer = $Timers/SpawnTimer
@onready var dash_timer: Timer = $Timers/DashTimer
@onready var dash_cooldown_timer: Timer = $Timers/DashCooldownTimer



#raycasts
@onready var ray_cast_left: RayCast2D = $RayCasts/RayCastLeft
@onready var ray_cast_left_2: RayCast2D = $RayCasts/RayCastLeft2
@onready var ray_cast_right: RayCast2D = $RayCasts/RayCastRight
@onready var ray_cast_right_2: RayCast2D = $RayCasts/RayCastRight2
@onready var ray_cast_up: RayCast2D = $RayCasts/RayCastUp





#particles
@onready var poof: CPUParticles2D = $Particles/Poof
@onready var crack_one: CPUParticles2D = $Particles/crack_one
@onready var crack_two: CPUParticles2D = $Particles/crack_two
@onready var crack_three: CPUParticles2D = $Particles/crack_three
@onready var crack_four: CPUParticles2D = $Particles/crack_four
@onready var circle_zap_anim: AnimatedSprite2D = $Particles/CircleZapAnim
@onready var brain_absorb_particle_effect: CPUParticles2D = $Particles/BrainAbsorbParticleEffect

@onready var salt_absorb_particle_effect: CPUParticles2D = $Particles/SaltAbsorbParticleEffect



@export var spark_scene : PackedScene

var speed_sample_position: float = 0.0



var current_speed : float

var normal_speed : float = 200.0
var slide_speed : float = 400.0
var dash_power : float = 400.0

var wall_slide_speed : float = .6

var acceleration : float = .2
var decceleration : float = .1

var air_acceleration : float = .1
var air_decceleration : float = .01

var air_dashing_accel : float = -.5
var air_dashing_deccel : float = -1 


var jump_velocity = -325.0
var jump_cancelled : bool = false

var bounce_velocity : float = 600

var is_sliding : bool = false

var is_dashing : bool = false
var dash_dir : float = 1.0
var can_dash : bool = true

var slide_on_cooldown : bool = false
var dash_on_cooldown: bool = false

var wall_jump_direction : float

var override_wallslide : bool = false


var max_camera_x : int = 40
var min_camera_x : int = -40
var neutral_camera_x : int = 0

var can_jump : bool = true


var direction : float

func _ready() -> void:
	
	
	add_to_group("player")
	
	current_speed = normal_speed
	spawn_timer.start()
	GameState.player_is_wall_sliding = false
	GameState.player_can_attack = true
	GameState.player_is_attacking = false
	
	
	if RoomChangeGlobal.activate:
		global_position = RoomChangeGlobal.player_pos
		if RoomChangeGlobal.player_jump_on_enter:
			velocity.y = jump_velocity
		RoomChangeGlobal.activate = false
	
	
	GlobalSignalBus.connect("essence_collect", essence_collect)
	GlobalSignalBus.connect("salt_collect", salt_collect)
	
	GlobalSignalBus.emit_signal("health_check")



func _process(delta: float) -> void:
	
	
	GameState.player_is_sliding = is_sliding
	GameState.player_location = global_position
	GameState.player_direction = direction
	GameState.player_is_on_ground = is_on_floor()

	if not GameState.is_being_hit:
		if GameState.player_is_wall_sliding:
			set_animation("Wall Sliding")
		else:
			if is_on_floor():
				if direction:
					if is_sliding:
						set_animation("Ground Sliding")
					else:
						set_animation("Walking")
				else:
					if is_sliding:
						set_animation("Ground Sliding")
					else:
						set_animation("Idle")
			else:
				if is_dashing:
					set_animation("Dashing")
				else:
					set_animation("Idle")
	else:
		set_animation("Crack")
	
	if not is_dashing and not is_sliding:
		if direction < 0:
			peanut_anims.flip_h = true
		elif direction > 0:
			peanut_anims.flip_h = false
	
	
	if not is_on_floor():
		if (ray_cast_left.is_colliding() or ray_cast_right.is_colliding() or ray_cast_left_2.is_colliding() or ray_cast_right_2.is_colliding()):
			GameState.player_is_wall_sliding = true
			if ray_cast_left.is_colliding() or ray_cast_left_2.is_colliding():
				peanut_anims.flip_h = true
				wall_jump_direction = 1
			elif ray_cast_right.is_colliding() or ray_cast_right_2.is_colliding():
				peanut_anims.flip_h = false
				wall_jump_direction = -1
				
		else:
			GameState.player_is_wall_sliding = false
	else:
		GameState.player_is_wall_sliding = false 
	






func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		is_sliding = false
	else:
		is_dashing = false

	# Handle jump.
	if Input.is_action_just_pressed("jump") and can_jump:
		wall_slide_wait_timer.start()
		jump_buffer_timer.start()
		
	if not jump_buffer_timer.is_stopped() and (is_on_floor() or not coyote_timer.is_stopped()):
		velocity.y = jump_velocity
		jump_buffer_timer.stop()
		coyote_timer.stop()
	
	if not jump_buffer_timer.is_stopped() and (is_on_wall() or not wall_coyote_timer.is_stopped()):
		velocity.y = jump_velocity
		velocity.x = current_speed * wall_jump_direction
		jump_buffer_timer.stop()
		coyote_timer.stop()

	if Input.is_action_just_released("jump") and !jump_cancelled:
		jump_cancelled = true
		velocity.y *= .4

	if is_on_floor():
		jump_cancelled = false
		can_dash = true
	

#Movement
	direction = Input.get_axis("move_left", "move_right")
	if direction:
		if is_on_floor(): 
			velocity.x = lerp(velocity.x, current_speed * direction, acceleration)
		else:
			velocity.x = lerp(velocity.x, current_speed * direction, air_acceleration)

	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, current_speed * decceleration)
		else:
			velocity.x = lerp(velocity.x, current_speed * direction, air_decceleration)

	
	if direction:
		if direction < 0:
			GameState.last_dir = -1
		if direction > 0:
			GameState.last_dir = 1
		

#Wallslide logic
	if GameState.player_is_wall_sliding and not is_on_floor():
		if wall_slide_wait_timer.is_stopped():
			velocity.y *= wall_slide_speed
	
	if is_dashing:
		velocity.x = dash_power * dash_dir
		velocity.y *= .9
	
	if is_sliding:
		velocity.x = slide_speed * dash_dir
		sliding_collision_shape.disabled = false
		standing_collision_shape.disabled = true
		
		if ray_cast_up.is_colliding():
			can_jump = false
	else:
		sliding_collision_shape.disabled = true
		standing_collision_shape.disabled = false
	
	
	var was_on_floor = is_on_floor()
	var was_on_wall = is_on_wall()
	
	
	
	move_and_slide()
	
	if was_on_floor and not is_on_floor():
		coyote_timer.start()
	
	if was_on_wall and not is_on_wall():
		wall_coyote_timer.start()
		
	
 
func _input(event: InputEvent) -> void:
	
	
	if event.is_action_pressed("special_l") or event.is_action_pressed("special_r"):
		if GameState.current_salt >= 1:
			GlobalSignalBus.emit_signal("slow_down_start")
			GameState.freeze_frame(GameState.current_slow_down_power, GameState.current_slow_down_length)
			GameState.current_salt -= 1
			GlobalSignalBus.emit_signal("salt_update")

	if event.is_action_pressed("Slide"):
		dash_dir = GameState.last_dir
		if is_on_floor():
			if not is_sliding and not slide_on_cooldown:
				slide_on_cooldown = true
				slide_cooldown_timer.start()
				is_sliding = true
				slide_timer.start()
		else:
			if can_dash and not dash_on_cooldown:
				dash_on_cooldown = true
				dash_cooldown_timer.start()
				dash_timer.start()
				is_dashing = true

	






func set_animation(anim : String):
	if peanut_anims.animation != anim:
		peanut_anims.play(anim)

func spawn_spark(world_location : Vector2):
	if spark_scene:
		var spark_instance = spark_scene.instantiate()
		get_tree().current_scene.add_child(spark_instance)
		spark_instance.global_position = world_location

func _on_turn_timer_timeout() -> void:
	if direction < 0:
		peanut_anims.flip_h = true
	elif direction > 0:
		peanut_anims.flip_h = false


func _on_slide_timer_timeout() -> void:
	if ray_cast_up.is_colliding():
		can_jump = false
		slide_timer.start()
	else:
		can_jump = true
		is_sliding = false


func instant_death():
	print("you died")


func take_damage(attack_dir : Vector2):
	
	var random_num = randi_range(1,4)
	if random_num == 1:
		crack_one.emitting = true
	elif random_num == 2:
		crack_two.emitting = true
	elif random_num == 3:
		crack_three.emitting = true
	elif random_num == 4:
		crack_four.emitting = true
	
	var knockback_dir : Vector2 = (global_position - attack_dir).normalized()
	GameState.knockback_direction = knockback_dir
	
	if not GameState.is_invul:
		GameState.player_invul(.5)
		if GameState.current_health > 0:
			GameState.freeze_frame(.1, .4)
			velocity = knockback_dir * 500
			GameState.current_health -= 1
			GlobalSignalBus.emit_signal("health_check")
			if GameState.current_health < 1:
				die()

func take_laser_damage():
	GameState.current_health = 0
	GlobalSignalBus.emit_signal("health_check")
	die()



func die():
	GameState.freeze_frame(.1, .4)
	GlobalSignalBus.emit_signal("shelled_peanut_died")
	queue_free()


func _on_dash_timer_timeout() -> void:
	is_dashing = false


func essence_collect():
	brain_absorb_particle_effect.emitting = true
	await get_tree().create_timer(.2).timeout
	circle_zap_anim.play("default")


func _on_dash_cooldown_timer_timeout() -> void:
	dash_on_cooldown = false


func _on_slide_cooldown_timer_timeout() -> void:
	slide_on_cooldown = false


func bounce(bounce_dir : Vector2, bounce_multiplier : float):
	velocity = bounce_dir * bounce_velocity * bounce_multiplier

func salt_collect():
	salt_absorb_particle_effect.emitting = true
