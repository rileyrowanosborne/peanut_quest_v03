extends CharacterBody2D


@onready var movement_delay_timer: Timer = $MovementDelayTimer

var health : int = 3

@export var speed : float = 50
@export var movement_delay_amount : float = 0.1

var current_dir = Vector2.ZERO

var in_range : bool = false

var player_pos : Vector2

func _ready() -> void:
	movement_delay_timer.start(movement_delay_amount)
	


func _input(event: InputEvent) -> void:
	
	if in_range:
		if event.is_action_pressed("action") and GameState.sword_is_active:
			health -= 1




func _physics_process(delta: float) -> void:
	var movement_velocity = current_dir.normalized() * speed
	
	velocity = movement_velocity
	
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		current_dir = current_dir.bounce(collision.get_normal())
		

func _on_movement_delay_timer_timeout() -> void:
	current_dir = Vector2((randf_range(-1,1)), randf_range(-1,1))


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = true
		player_pos = body.global_position


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = false
