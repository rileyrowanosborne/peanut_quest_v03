extends CharacterBody2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var turn_timer: Timer = $TurnTimer
@onready var standing_collision_shape: CollisionShape2D = $StandingCollisionShape
@onready var sliding_collision_shape: CollisionShape2D = $SlidingCollisionShape



@onready var slide_cooldown_timer: Timer = $SlideCooldownTimer
@onready var slide_timer: Timer = $"Slide Timer"
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


@onready var mega_sword: Node2D = $MegaSword


@export var spark_scene : PackedScene



var current_speed : float

var normal_speed : float = 200.0
var slide_speed : float = 400.0

var wall_slide_speed : float = .6

var acceleration : float = .2
var decceleration : float = .1

var air_acceleration : float = .1
var air_decceleration : float = .01


var jump_velocity = -325.0
var jump_cancelled : bool = false

var is_sliding : bool = false
var is_slide_jumping : bool = false

var wall_jump_direction : float


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

	


func _process(delta: float) -> void:
	
	GameState.player_is_sliding = is_sliding
	GameState.player_location = global_position
	GameState.player_direction = direction
	GameState.player_is_on_ground = is_on_floor()

	
	if GameState.player_is_wall_sliding:
		set_animation("Wall Sliding")
	else:
		if direction:
			if direction < 0:
				animated_sprite_2d.flip_h = true
			elif direction > 0:
				animated_sprite_2d.flip_h = false
			if is_on_floor():
				if is_sliding:
					set_animation("Ground Sliding")
				else:
					set_animation("Walking")
			else:
				set_animation("Idle")
		else:
			set_animation("Idle")

	

	
	if (ray_cast_left.is_colliding() or ray_cast_right.is_colliding() or ray_cast_left_2.is_colliding() or ray_cast_right_2.is_colliding()) and not is_on_floor():
		GameState.player_is_wall_sliding = true
		if ray_cast_left.is_colliding() or ray_cast_left_2.is_colliding():
			animated_sprite_2d.flip_h = true
			wall_jump_direction = 1
		elif ray_cast_right.is_colliding() or ray_cast_right_2.is_colliding():
			animated_sprite_2d.flip_h = false
			wall_jump_direction = -1
	else:
		GameState.player_is_wall_sliding = false

	



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		is_sliding = false

	# Handle jump.
	if Input.is_action_just_pressed("jump") and can_jump:
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
		is_slide_jumping = false
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("move_left", "move_right")
	if direction:
		if is_on_floor():
			velocity.x = lerp(velocity.x, current_speed * direction, acceleration)
		else:
			if not is_slide_jumping:
				velocity.x = lerp(velocity.x, current_speed * direction, air_acceleration)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, current_speed * decceleration)
		else:
			velocity.x = move_toward(velocity.x, 0, current_speed * air_decceleration)
	
	if is_on_wall() and not is_on_floor():
		velocity.y *= wall_slide_speed
	
	
	
	if is_sliding:
		current_speed = slide_speed
		sliding_collision_shape.disabled = false
		standing_collision_shape.disabled = true
	else:
		current_speed = normal_speed
		sliding_collision_shape.disabled = true
		standing_collision_shape.disabled = false
	
	if is_slide_jumping:
		air_acceleration = 0
	
	var was_on_floor = is_on_floor()
	var was_on_wall = is_on_wall()
	
	move_and_slide()
	
	if was_on_floor and not is_on_floor():
		coyote_timer.start()
	
	if was_on_wall and not is_on_wall():
		wall_coyote_timer.start()
	
 


func _input(event: InputEvent) -> void:
	if is_on_floor() and not is_sliding:
		if event.is_action_pressed("Slide") and direction != 0:
			is_sliding = true
			slide_timer.start()
	
	if is_sliding and event.is_action_pressed("jump"):
		if (is_on_floor() or not coyote_timer.is_stopped()):
			is_slide_jumping = true
			spawn_spark(global_position)
	
	

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


func _on_slide_timer_timeout() -> void:
	if ray_cast_up.is_colliding():
		can_jump = false
		slide_timer.start()
	else:
		can_jump = true
		is_sliding = false


func despawn():
	queue_free()


func _on_spawn_timer_timeout() -> void:
	poof.emitting = true
