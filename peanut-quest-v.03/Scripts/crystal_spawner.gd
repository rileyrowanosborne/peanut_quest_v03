extends Node2D



@export var crystal_scene : PackedScene

var crystal_instance


func _ready() -> void:
	GlobalSignalBus.connect("mage_deactivate", respawn_crystal)
	
	
	spawn_crystal(global_position)



func respawn_crystal():
	if crystal_instance == null:
		spawn_crystal(global_position)


func spawn_crystal(world_location : Vector2):
	
	if crystal_scene:
		crystal_instance = crystal_scene.instantiate()
		get_tree().current_scene.add_child.call_deferred(crystal_instance)
		crystal_instance.global_position = world_location
