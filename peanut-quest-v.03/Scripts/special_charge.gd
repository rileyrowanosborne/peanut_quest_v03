extends CPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignalBus.connect("essence_update", essence_update)
	
	essence_update()



func essence_update():
	
	if GameState.current_brain_essence == 0:
		emitting = false
	else:
		emitting = true

	match GameState.current_brain_essence:
		1:
			amount = 1
		2:
			amount = 2
		3:
			amount = 3
		4:
			amount = 4
		5:
			amount = 5
		6:
			amount = 6
		7:
			amount = 7
		8:
			amount = 8
		9:
			amount = 9
		10:
			amount = 10
		
