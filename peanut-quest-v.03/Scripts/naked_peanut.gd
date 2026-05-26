extends CharacterBody2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var turn_timer: Timer = $TurnTimer
@onready var standing_collision_shape: CollisionShape2D = $StandingCollisionShape


@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var wall_coyote_timer: Timer = $WallCoyoteTimer

@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_left_2: RayCast2D = $RayCastLeft2

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_right_2: RayCast2D = $RayCastRight2
@onready var ray_cast_up: RayCast2D = $RayCastUp

@onready var poof: CPUParticles2D = $Poof
@onready var spawn_timer: Timer = $SpawnTimer
@onready var wall_slide_wait_timer: Timer = $WallSlideWaitTimer


@onready var salt_absorb_particle_effect: CPUParticles2D = $SaltAbsorbParticleEffect
@onready var brain_absorb_particle_effect: CPUParticles2D = $BrainAbsorbParticleEffect


@onready var circle_zap_anim: AnimatedSprite2D = $CircleZapAnim


@export var spark_scene : PackedScene



var current_speed : float

var normal_speed : float = 275.0

var wall_slide_speed : float = .6

var acceleration : float = .2
var decceleration : float = .1

var air_acceleration : float = .1
var air_decceleration : float = .01


var jump_velocity = -325.0
var jump_cancelled : bool = false

var wall_jump_direction : float


var max_camera_x : int = 40
var min_camera_x : int = -40
var neutral_camera_x : int = 0


var direction : float

var knockback_dir : Vector2

var alive : bool = true

var bounce_velocity : float = 600
	


func _ready() -> void:
	
	add_to_group("player")
	GlobalSignalBus.emit_signal("health_check")
	GlobalSignalBus.connect("essence_collect", essence_collect)
	
	alive = true
	
	GlobalSignalBus.connect("reshell_peanut", reshell)
	
	
	velocity = GameState.knockback_direction * 500
	current_speed = normal_speed
	spawn_timer.start()
	GameState.player_invul(1)


func _process(delta: float) -> void:
	
	GameState.player_direction = direction
	GameState.player_location = global_position
	
	if alive:
		if GameState.player_is_wall_sliding:
			set_animation("Wall Sliding")
		else:
			if direction:
				if turn_timer.is_stopped():
					turn_timer.start()
				if is_on_floor():
					set_animation("Walking")
				else:
					set_animation("Idle")
			else:
				set_animation("Idle")
	else:
		set_animation("Death")
	
	if not is_on_floor():
		if (ray_cast_left.is_colliding() or ray_cast_right.is_colliding() or ray_cast_left_2.is_colliding() or ray_cast_right_2.is_colliding()):
			GameState.player_is_wall_sliding = true
			if ray_cast_left.is_colliding() or ray_cast_left_2.is_colliding():
				animated_sprite_2d.flip_h = true
				wall_jump_direction = 1
			elif ray_cast_right.is_colliding() or ray_cast_right_2.is_colliding():
				animated_sprite_2d.flip_h = false
				wall_jump_direction = -1
		else:
			GameState.player_is_wall_sliding = false
	else:
		GameState.player_is_wall_sliding = false 



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
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
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("move_left", "move_right")
	if direction:
		if is_on_floor():
			velocity.x = lerp(velocity.x, current_speed * direction, acceleration)
		else:
			velocity.x = lerp(velocity.x, current_speed * direction, air_acceleration)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0.0, current_speed * decceleration)
		else:
			velocity.x = move_toward(velocity.x, 0.0, current_speed * air_decceleration)
	
	
	if GameState.player_is_wall_sliding and not is_on_floor():
		if wall_slide_wait_timer.is_stopped():
			velocity.y *= wall_slide_speed
	
	
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


func set_animation(anim : String):
	if animated_sprite_2d.animation != anim:
		animated_sprite_2d.play(anim)

func spawn_spark(world_location : Vector2):
	if spark_scene:
		var spark_instance = spark_scene.instantiate()
		get_tree().current_scene.add_child(spark_instance)
		spark_instance.global_position = world_location

func _on_turn_timer_timeout() -> void:
	if direction < 0:
		animated_sprite_2d.flip_h = true
	elif direction > 0:
		animated_sprite_2d.flip_h = false


func take_damage(attack_dir : Vector2):
	
	knockback_dir = (global_position - attack_dir).normalized()
	
	if not GameState.is_invul:
		die()


func die():
	current_speed = 0.0
	rotate(atan2(knockback_dir.x, knockback_dir.y))
	velocity = knockback_dir * 2000
	GameState.freeze_frame(.1, .4)
	await get_tree().create_timer(.4).timeout
	GlobalSignalBus.emit_signal("respawn_peanut")
	queue_free()

func reshell():
	queue_free()


func take_laser_damage():
	if not GameState.is_invul:
		alive = false
		velocity.y = jump_velocity
		GameState.freeze_frame(.1, .4)
		await get_tree().create_timer(.4).timeout

		GlobalSignalBus.emit_signal("respawn_peanut")
		queue_free()
	
	

func _on_spawn_timer_timeout() -> void:
	poof.emitting = true



func essence_collect():
	brain_absorb_particle_effect.emitting = true
	await get_tree().create_timer(.2).timeout
	circle_zap_anim.play("default")

func salt_collect():
	salt_absorb_particle_effect.emitting = true


func bounce(bounce_dir : Vector2, bounce_multiplier : float):
	
	
	velocity = bounce_dir * bounce_velocity * bounce_multiplier
