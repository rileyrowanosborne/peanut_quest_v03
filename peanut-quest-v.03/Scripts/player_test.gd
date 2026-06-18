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

@onready var camera_aim: Marker2D = $CameraAim


@export var spark_scene : PackedScene


var speed_sample_position: float = 0.0



var current_speed : float
var neutral_speed : float = 175.0
var slime_speed : float = 150.0

var current_jump : float
var neutral_jump : float = -325.0
var slime_jump : float = -450.0



var current_dash_power : float
var neutral_dash_power : float = 350.0
var slime_dash_power : float = 450

var current_dash_length : float
var neutral_dash_length : float = .2
var slime_dash_length : float = .3


var dash_invul_length : float = .4

var current_wall_slide_speed : float = .4


var athletic_wall_speed : float = 0.1

var min_wall_slide_speed : float = .1
var max_wall_slide_speed : float = .7

var wall_slide_decay : float = .9

var acceleration : float = .2
var decceleration : float = .1

var air_acceleration : float = .1
var air_decceleration : float = .01

var air_dashing_accel : float = -.5
var air_dashing_deccel : float = -1 


var neutral_multiplier : float = 1.0
var athletic_multiplier : float = 1.3

var current_multiplier : float = 1.0


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
var jump_requested = false

var direction : float

func _ready() -> void:
	
	GameState.player_is_shelled = true
	
	add_to_group("player")
	
	current_dash_length = neutral_dash_length
	current_dash_power = neutral_dash_power
	current_jump = neutral_jump
	current_speed = neutral_speed
	current_multiplier = neutral_multiplier
	spawn_timer.start()
	GameState.player_is_wall_sliding = false
	GameState.player_can_attack = true
	GameState.player_is_attacking = false
	
	
	
	
	if RoomChangeGlobal.activate:
		global_position = RoomChangeGlobal.player_pos
		if RoomChangeGlobal.player_jump_on_enter:
			velocity.y = current_jump
		RoomChangeGlobal.activate = false
	
	
	GlobalSignalBus.connect("essence_collect", essence_collect)
	GlobalSignalBus.connect("salt_collect", salt_collect)
	
	GlobalSignalBus.connect("slime_activate", slime_activate)
	
	GlobalSignalBus.connect("monk_activate", monk_activate)
	
	
	GlobalSignalBus.emit_signal("health_check")



func _process(delta: float) -> void:
	
	
	GameState.player_is_sliding = is_sliding
	GameState.player_location = global_position
	GameState.player_direction = direction
	GameState.player_is_on_ground = is_on_floor()
	GameState.camera_aim_location = camera_aim.global_position
	
	

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
			can_jump = true
			if GameState.monk_is_active:
				current_wall_slide_speed = athletic_wall_speed
			else:
				if current_wall_slide_speed < max_wall_slide_speed:
					current_wall_slide_speed += wall_slide_decay * delta
			if ray_cast_left.is_colliding() or ray_cast_left_2.is_colliding():
				peanut_anims.flip_h = true
				wall_jump_direction = 1
			elif ray_cast_right.is_colliding() or ray_cast_right_2.is_colliding():
				peanut_anims.flip_h = false
				wall_jump_direction = -1
				
		else:
			GameState.player_is_wall_sliding = false
			current_wall_slide_speed = min_wall_slide_speed
	else:
		GameState.player_is_wall_sliding = false 
		current_wall_slide_speed = min_wall_slide_speed
	






func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		is_sliding = false
	else:
		if ray_cast_up.is_colliding():
			can_jump = false
		else:
			can_jump = true
		is_dashing = false
		

	#Movement
	if GameState.ready_for_input:
		direction = Input.get_axis("move_left", "move_right")
		if direction:
			if is_on_floor(): 
				velocity.x = lerp(velocity.x, current_speed * direction * current_multiplier, acceleration)
			else:
				velocity.x = lerp(velocity.x, current_speed * GameState.last_dir * current_multiplier, air_acceleration)

		else:
			if is_on_floor():
				velocity.x = move_toward(velocity.x, 0, current_speed * decceleration * current_multiplier)
			else:
				velocity.x = lerp(velocity.x, current_speed * direction, air_decceleration * current_multiplier)

		
		if direction:
			if direction < 0:
				GameState.last_dir = -1
			if direction > 0:
				GameState.last_dir = 1
		

#Wallslide logic
	if GameState.player_is_wall_sliding and not is_on_floor():
		if wall_slide_wait_timer.is_stopped():
			velocity.y *= current_wall_slide_speed
	
	if is_dashing:
		velocity.x = current_dash_power * dash_dir
		velocity.y *= .9
	
	if is_sliding:
		velocity.x = current_dash_power * dash_dir
		sliding_collision_shape.disabled = false
		standing_collision_shape.disabled = true
		
	else:
		sliding_collision_shape.disabled = true
		standing_collision_shape.disabled = false
	

	if GameState.ready_for_input:
		if Input.is_action_just_pressed("jump") and not jump_requested and can_jump:
			jump_requested = true
			jump_buffer_timer.start()
	
	
	if jump_requested:
		
		if is_on_floor() or not coyote_timer.is_stopped():
			jump()
			
		elif is_on_wall() or not wall_coyote_timer.is_stopped():
			wall_jump()
	
	if Input.is_action_just_released("jump") and !jump_cancelled:
		jump_requested = false
		jump_cancelled = true
		velocity.y *= .4
	
	
	
	
	var was_on_floor = is_on_floor()
	var was_on_wall = is_on_wall()
	
	
	
	move_and_slide()
	
	if was_on_floor and not is_on_floor():
		coyote_timer.start()
	
	if was_on_wall and not is_on_wall():
		wall_coyote_timer.start()
		

func jump():
	wall_slide_wait_timer.start()
	jump_requested = false
	jump_cancelled = false
	velocity.y = current_jump * current_multiplier
	jump_buffer_timer.stop()
	coyote_timer.stop()
	wall_coyote_timer.stop()

func wall_jump():
	wall_slide_wait_timer.start()
	jump_requested = false
	jump_cancelled = false
	velocity.y = current_jump * current_multiplier
	velocity.x = current_speed * wall_jump_direction
	jump_buffer_timer.stop()
	coyote_timer.stop()
	wall_coyote_timer.stop()

 
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Slide"):
		dash_dir = GameState.last_dir
		if is_on_floor():
			if not is_sliding and not slide_on_cooldown:
				GameState.player_invul(dash_invul_length)
				slide_on_cooldown = true
				slide_cooldown_timer.start()
				is_sliding = true
				slide_timer.start(current_dash_length)
		else:
			if can_dash and not dash_on_cooldown:
				GameState.player_invul(dash_invul_length)
				
				
				dash_on_cooldown = true
				dash_cooldown_timer.start()
				dash_timer.start(current_dash_length)
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
		GameState.player_invul(1)
		
		if GameState.current_health == 3:
			if GameState.knight_is_active:
				GlobalSignalBus.emit_signal("knight_deactivate")
			if GameState.monk_is_active:
				GlobalSignalBus.emit_signal("monk_deactivate")
				monk_deactivate()
			if GameState.mage_is_active:
				GlobalSignalBus.emit_signal("mage_deactivate")
				mage_deactivate()
			if GameState.slime_is_active:
				GlobalSignalBus.emit_signal("slime_deactivate")
				slime_deactivate()
			
			GameState.current_health = 2
			GlobalSignalBus.emit_signal("health_check")
			GameState.freeze_frame(.1, .4)
			velocity = knockback_dir * 500
		else:
			if GameState.current_health > 0:
				GameState.freeze_frame(.1, .4)
				velocity = knockback_dir * 500
				GameState.current_health -= 1
				GlobalSignalBus.emit_signal("health_check")
				if GameState.current_health < 1:
					die()
	active_power_ups()

func take_laser_damage():
	if GameState.current_health == 3:
		if GameState.knight_is_active:
				GlobalSignalBus.emit_signal("knight_deactivate")
		if GameState.monk_is_active:
			GlobalSignalBus.emit_signal("monk_deactivate")
			monk_deactivate()
		if GameState.mage_is_active:
			GlobalSignalBus.emit_signal("mage_deactivate")
			mage_deactivate()
		if GameState.slime_is_active:
			GlobalSignalBus.emit_signal("slime_deactivate")
			slime_deactivate()
		GameState.current_health = 2
		GlobalSignalBus.emit_signal("health_check")
		GameState.player_invul(1)
		GameState.freeze_frame(.1, .4)
		velocity.y = -400
	else:
		GameState.current_health = 0
		GlobalSignalBus.emit_signal("health_check")
		
		die()
		

func take_spike_damage():
	var random_num = randi_range(1,4)
	if random_num == 1:
		crack_one.emitting = true
	elif random_num == 2:
		crack_two.emitting = true
	elif random_num == 3:
		crack_three.emitting = true
	elif random_num == 4:
		crack_four.emitting = true
	
	if not GameState.is_invul:
		GameState.player_invul(1)
		
		if GameState.current_health == 3:
			if GameState.knight_is_active:
				GlobalSignalBus.emit_signal("knight_deactivate")
			if GameState.monk_is_active:
				GlobalSignalBus.emit_signal("monk_deactivate")
				monk_deactivate()
			if GameState.mage_is_active:
				GlobalSignalBus.emit_signal("mage_deactivate")
				mage_deactivate()
			if GameState.slime_is_active:
				GlobalSignalBus.emit_signal("slime_deactivate")
				slime_deactivate()
			GameState.current_health = 2
			GlobalSignalBus.emit_signal("health_check")
			GameState.freeze_frame(.1, .4)
			velocity.y = -400
		else:
			if GameState.current_health > 0:
				GameState.freeze_frame(.1, .4)
				velocity.y = -400
				GameState.current_health -= 1
				GlobalSignalBus.emit_signal("health_check")
				if GameState.current_health < 1:
					velocity.y = -400
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


func monk_activate():
	current_multiplier = athletic_multiplier

func monk_deactivate():
	GameState.monk_is_active = false
	current_multiplier = neutral_multiplier

func mage_activate():
	pass

func mage_deactivate():
	GameState.mage_is_active = false

func slime_activate():
	current_jump = slime_jump
	current_dash_power = slime_dash_power
	current_dash_length = slime_dash_length
	

func slime_deactivate():
	current_jump = neutral_jump
	current_dash_power = neutral_dash_power
	current_dash_length = neutral_dash_length
	GameState.slime_is_active = false

func active_power_ups():
	print("knight: " + str(GameState.knight_is_active))
	print("monk: " + str(GameState.monk_is_active))
	print("mage: " + str(GameState.mage_is_active))



func _on_jump_buffer_timer_timeout() -> void:
	jump_requested = false


func _on_spike_hit_box_body_entered(body: Node2D) -> void:
	take_spike_damage()
