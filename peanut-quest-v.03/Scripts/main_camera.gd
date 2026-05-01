extends Camera2D


var camera_offset_x := 0


var max_camera_x : int = 40
var min_camera_x : int = -40
var neutral_camera_x : int = 0


@export var is_following_player : bool = false
@export var camera_zoom : Vector2 = Vector2(3.5,3.5)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_following_player:
		if GameState.player_direction < 0:
			camera_offset_x = max(camera_offset_x - 2, min_camera_x)
		elif GameState.player_direction > 0:
			camera_offset_x = min(camera_offset_x + 2, max_camera_x)
		else:
			if camera_offset_x > neutral_camera_x:
				camera_offset_x -= 1
			elif camera_offset_x < neutral_camera_x:
				camera_offset_x += 1
		
		global_position = Vector2(
			GameState.player_location.x + camera_offset_x,
			GameState.player_location.y - 30
		)
		
		zoom = camera_zoom
