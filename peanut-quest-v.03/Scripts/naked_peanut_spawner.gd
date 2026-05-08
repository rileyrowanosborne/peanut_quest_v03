extends Node2D


@export var naked_peanut_scene : PackedScene


func _ready() -> void:
	GlobalSignalBus.connect("shelled_peanut_died", spawn_naked_peanut)


func spawn_naked_peanut():
	if naked_peanut_scene:
		var naked_peanut_instance = naked_peanut_scene.instantiate()
		get_tree().current_scene.call_deferred("add_child", naked_peanut_instance)
		naked_peanut_instance.global_position = global_position
