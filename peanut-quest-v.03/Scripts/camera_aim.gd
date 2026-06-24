extends Marker2D



var max_x : float = 60
var min_x : float = -60

var neutral_x : float = 0



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if not GameState.player_direction:
		if position.x < neutral_x:
			position.x += 100 * delta
		elif position.x > neutral_x:
			position.x -= 100 * delta
	else:
		if GameState.player_direction < 0:
			if position.x > min_x:
				position.x -= 100 * delta
		if GameState.player_direction > 0:
			if position.x < max_x:
				position.x += 100 * delta
