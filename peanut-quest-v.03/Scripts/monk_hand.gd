extends Node2D








func _ready() -> void:
	GlobalSignalBus.connect("monk_deactivate", despawn_hand)
	
	
	


func despawn_hand():
	queue_free()
