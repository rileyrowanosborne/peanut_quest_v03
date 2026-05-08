extends Node

var player_direction : float
var last_dir : float

var player_is_sliding  : bool

var player_is_on_ground : bool


var player_location : Vector2

var player_is_wall_sliding : bool

var player_is_attacking : bool
var player_can_attack : bool
var current_swing_delay : float = .4


var current_health : int = 2
var current_max_health : int = 2


var swing_combo_active : bool = false


var slide_blocking_attack : bool = false





func _ready() -> void:
	player_is_attacking = false
	player_can_attack = true
