extends CPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	emitting = true
	
	GlobalSignalBus.connect("salt_update", salt_update)
	
	
	salt_update()



func salt_update():
	
	if GameState.current_salt == 0:
		emitting = false
	else:
		emitting = true

	match GameState.current_salt:
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
		
