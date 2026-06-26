extends Node2D



@export var crystal_scene : PackedScene

var crystal_instance

var in_range : bool = false



	#spawn_crystal(global_position)

func _input(event: InputEvent) -> void:
	
	if in_range:
		if event.is_action_pressed("interact") and GameState.player_is_shelled:
			if not GameState.mage_is_active:
				GameState.current_health = 3
				GlobalSignalBus.emit_signal("mage_activate")
				GameState.mage_is_active = true
				GlobalSignalBus.emit_signal("health_check")
				GlobalSignalBus.emit_signal("class_update")
			else:
				GlobalSignalBus.emit_signal("mage_deactivate")
				GameState.mage_is_active = false
				GlobalSignalBus.emit_signal("health_check")
				GlobalSignalBus.emit_signal("class_update")



#func respawn_crystal():
	#if crystal_instance == null:
		#spawn_crystal(global_position)


#func spawn_crystal(world_location : Vector2):
	#
	#if crystal_scene:
		#crystal_instance = crystal_scene.instantiate()
		#get_tree().current_scene.add_child.call_deferred(crystal_instance)
		#crystal_instance.global_position = world_location


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = false
