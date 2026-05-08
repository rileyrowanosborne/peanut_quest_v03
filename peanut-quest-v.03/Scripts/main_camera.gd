extends Camera2D


var camera_offset_x := 0
var camera_offset_y := 0


var max_camera_x : int = 60
var min_camera_x : int = -60
var neutral_camera_x : int = 0

var max_camera_y : int = -50
var neutral_camera_y : int = 30


var is_looking_down : bool = false

@export var is_following_player : bool = false
@export var camera_zoom : Vector2 = Vector2(3.5,3.5)



func _ready() -> void:
	if is_following_player:
		global_position = GameState.player_location


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_down") and GameState.player_is_on_ground and GameState.player_direction == 0:
		await get_tree().create_timer(.5).timeout
		is_looking_down = true
		
	

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
		
		
		if not Input.is_action_pressed("move_down"):
			is_looking_down = false
		
		
		if is_looking_down:
			if camera_offset_y > max_camera_y:
				camera_offset_y -= 5
		else:
			if camera_offset_y < neutral_camera_y:
				camera_offset_y += 5
		
		
		global_position = Vector2(
			GameState.player_location.x + camera_offset_x,
			GameState.player_location.y - camera_offset_y
		)
		
		zoom = camera_zoom
