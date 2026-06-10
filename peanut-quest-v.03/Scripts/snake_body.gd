extends CharacterBody2D


@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var movement_delay_timer: Timer = $MovementDelayTimer


@export var speed : float = 50
@export var movement_delay_amount : float = 0.1

var current_dir = Vector2.ZERO



func _ready() -> void:
	
	movement_delay_timer.start(movement_delay_amount)
		
	add_to_group("enemy")



func _physics_process(delta: float) -> void:
	
	
	
	var movement_velocity = current_dir.normalized() * speed
	
	velocity = movement_velocity
	
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		current_dir = current_dir.bounce(collision.get_normal())
		
	
	rotation = velocity.angle()
	
	


func _on_movement_delay_timer_timeout() -> void:
	current_dir = get_parent().get_parent().direction


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(global_position)
