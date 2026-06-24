extends RigidBody2D



var initial_y_velocity : float = -300

var initial_x_velocity : float = 300


@export var explosion_scene : PackedScene



func _ready() -> void:
	apply_central_impulse(Vector2(initial_x_velocity * GameState.last_dir, initial_y_velocity))


func _on_area_2d_body_entered(body: Node2D) -> void:
	explode()

func _physics_process(delta: float) -> void:
	
	rotation = linear_velocity.angle()

func explode():
	print("Boom!")
	spawn_explosion(global_position)
	queue_free()



func spawn_explosion(world_location : Vector2):
	if explosion_scene:
		var explosion_instance = explosion_scene.instantiate()
		get_tree().current_scene.call_deferred("add_child", explosion_instance)
		explosion_instance.global_position = world_location
		
