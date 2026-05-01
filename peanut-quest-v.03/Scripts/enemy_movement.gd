extends CharacterBody2D



@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var direction_cooldown: Timer = $DirectionCooldown
@onready var direction_timer: Timer = $DirectionTimer




var speed : float = 50
var current_direction : int = 0

enum movement_states {
	idle,
	walking,
	spinning
}

var current_state : movement_states


func _ready() -> void:
	change_direction()
	
	direction_timer.start()


func _process(delta: float) -> void:
	if ray_cast_left.is_colliding():
		current_direction = 1
		direction_cooldown.start()
	if ray_cast_right.is_colliding():
		current_direction = -1
		direction_cooldown.start()
	
	if current_direction < 0:
		animated_sprite_2d.flip_h = true
	elif current_direction > 0:
		animated_sprite_2d.flip_h = false
	
	if current_direction != 0:
		current_state = movement_states.walking
	else:
		current_state = movement_states.idle
	
	
	match current_state:
		
		movement_states.idle:
			set_animation("Idle")
		
		movement_states.walking:
			set_animation("Walking")
		
		movement_states.spinning:
			set_animation("Spinning")




func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.x = speed * current_direction
	
	move_and_slide()




func change_direction():
	if direction_cooldown.is_stopped():
		direction_cooldown.start()
		var new_direction = randi_range(-1,1)
		current_direction = new_direction

func set_animation(anim : String):
	if animated_sprite_2d.animation != anim:
		animated_sprite_2d.play(anim)


func _on_direction_timer_timeout() -> void:
	change_direction()
	direction_timer.start()
