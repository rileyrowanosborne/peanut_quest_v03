extends Node2D




@export var sword_scene : PackedScene


var sword_instance



func _ready() -> void:
	
	GlobalSignalBus.connect("sword_activate", spawn_sword)
	
	GlobalSignalBus.connect("sword_deactivate", despawn_sword)




func spawn_sword():
	if not GameState.sword_is_active:
		if sword_scene:
			sword_instance = sword_scene.instantiate()
			get_parent().add_child(sword_instance)


func despawn_sword():
	if GameState.sword_is_active:
		if sword_instance != null:
			sword_instance.queue_free()
		GameState.sword_is_active = false
