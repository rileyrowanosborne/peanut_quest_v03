extends Node

var player_direction : float
var last_dir : float

var player_is_sliding  : bool

var player_is_on_ground : bool


var player_location : Vector2

var player_is_wall_sliding : bool

var player_is_attacking : bool
var player_can_attack : bool
var current_swing_delay : float = 1.0


func _ready() -> void:
	last_dir = -1
	player_is_attacking = false
	player_can_attack = true


func _process(delta: float) -> void:

	if GameState.player_direction == -1:
		GameState.last_dir = -1
	elif GameState.player_direction == 1:
		GameState.last_dir = 1
