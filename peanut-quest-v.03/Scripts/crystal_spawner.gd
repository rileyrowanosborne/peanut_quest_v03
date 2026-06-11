extends Node2D



@export var crystal_scene : PackedScene


func _ready() -> void:
	GlobalSignalBus.connect("crystal_deactivate", respawn_crystal)
	
	
	spawn_crystal(global_position)



func respawn_crystal():
	spawn_crystal(global_position)


func spawn_crystal(world_location : Vector2):
	if crystal_scene:
		var crystal_instance = crystal_scene.instantiate()
		get_tree().current_scene.add_child.call_deferred(crystal_instance)
		crystal_instance.global_position = world_location
