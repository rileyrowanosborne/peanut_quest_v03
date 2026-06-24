extends Camera2D

@onready var initial_timer: Timer = $InitialTimer

var camera_offset_x : float = 0
var camera_offset_y : float = 0


var min_camera_x : float = -50
var neutral_camera_x : float = 0
var max_camera_x : float = 50

var max_camera_y : float = -50
var neutral_camera_y : float = 0
var min_camera_y : float = 50



var is_looking_down : bool = false
var is_looking_up : bool = false
var is_looking_right : bool = false
var is_looking_left : bool = false
var looking_around : bool = false


@export var is_following_player : bool = true

@export var camera_zoom : Vector2 = Vector2(3,3)

var controller_active: bool

var pan_strength : float = 5

func _ready() -> void:
	pan_strength = .1
	initial_timer.start()
	
	if is_following_player:
		global_position = GameState.camera_aim_location


func _input(event: InputEvent) -> void:
	if GameState.ready_for_input:
		#camera pan down
		if event.is_action_pressed("aim_down"):
			if not GameState.player_direction:
				is_looking_down = true

			else:
				is_looking_down = false
		
		if event.is_action_released("aim_down"):
			is_looking_down = false

		
		#camera pan right
		if event.is_action_pressed("aim_right"):
			if not GameState.player_direction:
				is_looking_right = true

			else:
				is_looking_right = false

		if event.is_action_released("aim_right"):
			is_looking_right = false

		
		#camera pan up
		if event.is_action_pressed("aim_up"):
			if not GameState.player_direction:
				is_looking_up = true

			else:
				is_looking_up = false

		if event.is_action_released("aim_up"):
			is_looking_up = false

		
		#camera pan left
		if event.is_action_pressed("aim_left"):
			if not GameState.player_direction:
				is_looking_left = true

			else:
				is_looking_left = false

		if event.is_action_released("aim_left"):
			is_looking_left = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if is_following_player:

		if is_looking_down:
			if camera_offset_y > max_camera_y:
				camera_offset_y -= pan_strength
		else:
			if camera_offset_y < neutral_camera_y:
				camera_offset_y += pan_strength
		
		if is_looking_up:
			if camera_offset_y < min_camera_y:
				camera_offset_y += pan_strength
		else:
			if camera_offset_y > neutral_camera_y:
				camera_offset_y -= pan_strength
		
		if is_looking_right:
			if camera_offset_x < max_camera_x:
				camera_offset_x += pan_strength
		else:
			if camera_offset_x > neutral_camera_x:
				camera_offset_x -= pan_strength
	
		if is_looking_left:
			if camera_offset_x > min_camera_x:
				camera_offset_x -= pan_strength
		else:
			if camera_offset_x < neutral_camera_x:
				camera_offset_x += pan_strength
	
	
#
		#if GameState.player_direction < 0:
			#camera_offset_x = max(camera_offset_x - 2, min_camera_x)
		#elif GameState.player_direction > 0:
			#camera_offset_x = min(camera_offset_x + 2, max_camera_x)
		#else:
			#if camera_offset_x > neutral_camera_x:
				#camera_offset_x -= 1
			#elif camera_offset_x < neutral_camera_x:
				#camera_offset_x += 1
	
		
		

		global_position = Vector2(
			GameState.camera_aim_location.x + camera_offset_x,
			GameState.camera_aim_location.y - camera_offset_y
		)
		
		if zoom < camera_zoom:
			zoom += Vector2(.5,.5) * delta


func _on_initial_timer_timeout() -> void:
	GameState.ready_for_input = true
	pan_strength = 5
