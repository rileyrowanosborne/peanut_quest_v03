extends Node2D


var is_active : bool = false

@export var projectile_scene : PackedScene




func _ready() -> void:
	GlobalSignalBus.connect("ability_update", class_update)



func _input(event: InputEvent) -> void:
	if is_active:
		if event.is_action_pressed("action"):
			spawn_projectile(global_position)



func class_update():
	if GameState.current_class == "Liquid Wizard":
		is_active = true

	else:
		is_active = false



func spawn_projectile(world_location : Vector2):
	if projectile_scene:
		var projectile_instance = projectile_scene.instantiate()
		get_tree().current_scene.call_deferred("add_child", projectile_instance)
		projectile_instance.global_position = world_location
