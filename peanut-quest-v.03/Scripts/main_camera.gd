extends Camera2D

@onready var initial_timer: Timer = $InitialTimer

var camera_offset_x := 0
var camera_offset_y := 0


var max_camera_x : int = 60
var min_camera_x : int = -60
var neutral_camera_x : int = 0

var max_camera_y : int = -50
var neutral_camera_y : int = 30


var is_looking_down : bool = false

@export var is_following_player : bool = true

@export var camera_zoom : Vector2 = Vector2(3,3)

var controller_active: bool



func _ready() -> void:
	
	initial_timer.start()
	
	if is_following_player:
		global_position = GameState.player_location


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("aim_down"):
		if not GameState.player_direction:
			is_looking_down = true
		
		else:
			is_looking_down = false
	
	if event.is_action_released("aim_down"):
		is_looking_down = false
	

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if not initial_timer.is_stopped():
		position_smoothing_speed = 50
	else:
		position_smoothing_speed = 3
	
	
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
