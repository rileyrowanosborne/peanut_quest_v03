extends CharacterBody2D




@export var speed : float = 10.0


var current_dir : Vector2


func _ready() -> void:
	add_to_group("enemy")
	current_dir = Vector2(randi_range(-1,1), randi_range(-1,1))
	await get_tree().create_timer(3).timeout
	change_direction()


func _physics_process(delta: float) -> void:
	
	velocity = current_dir * speed
	
	move_and_slide()



func change_direction():
	current_dir = Vector2(randi_range(-1,1), randi_range(-1,1))
	
	await get_tree().create_timer(3).timeout
	change_direction()



func take_damage(attack_dir : Vector2):
	
	var knockback_dir : Vector2 = (global_position - attack_dir).normalized()
	
	owner.current_health -= 1
	velocity = knockback_dir * 1000
	GameState.freeze_frame(.5,.4)
	
	print("heart hit!")
	
	if owner.current_health <= 0:
		owner.queue_free()
