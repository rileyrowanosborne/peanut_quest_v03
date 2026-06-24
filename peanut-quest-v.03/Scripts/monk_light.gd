extends Node2D

@export var projectile_scene : PackedScene 

func _input(event: InputEvent) -> void:
	if get_parent().get_parent().is_active:
		if event.is_action_pressed("action"):
			spawn_projectile(global_position)

func _process(delta: float) -> void:
	
	rotation_degrees -= GameState.monk_rotation_amount * delta



func spawn_projectile(world_location : Vector2):
	if projectile_scene:
		var projectile_instance = projectile_scene.instantiate()
		get_tree().current_scene.call_deferred("add_child", projectile_instance)
		projectile_instance.global_position = world_location
