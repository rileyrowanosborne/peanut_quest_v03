extends CharacterBody2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var turn_timer: Timer = $TurnTimer
@onready var camera_2d: Camera2D = $Camera2D



var speed = 200.0
var acceleration : float = .2
var decceleration : float = .1

var air_acceleration : float = .1
var air_decceleration : float = .05


var jump_velocity = -325.0
var jump_cancelled : bool = false


var max_camera_x : int = 40
var min_camera_x : int = -40
var neutral_camera_x : int = 0


var direction : float

func _process(delta: float) -> void:
	if direction:
		if turn_timer.is_stopped():
			turn_timer.start()
		if is_on_floor():
			set_animation("Walking")
		else:
			set_animation("Idle")
	else:
		set_animation("Idle")
	
	
	if direction < 0:
		if camera_2d.position.x > min_camera_x:
			camera_2d.position.x -= 2
	elif direction > 0:
		if camera_2d.position.x < max_camera_x:
			camera_2d.position.x += 2
	else:
		if camera_2d.position.x < neutral_camera_x:
			camera_2d.position.x += 1
		else:
			camera_2d.position.x -= 1



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
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
			velocity.x = lerp(velocity.x, speed * direction, acceleration)
		else:
			velocity.x = lerp(velocity.x, speed * direction, air_acceleration)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, speed * decceleration)
		else:
			velocity.x = move_toward(velocity.x, 0, speed * air_decceleration)

	move_and_slide()



func set_animation(anim : String):
	if animated_sprite_2d.animation != anim:
		animated_sprite_2d.play(anim)
	
	


func _on_turn_timer_timeout() -> void:
	if direction < 0:
		animated_sprite_2d.flip_h = true
	elif direction > 0:
		animated_sprite_2d.flip_h = false
