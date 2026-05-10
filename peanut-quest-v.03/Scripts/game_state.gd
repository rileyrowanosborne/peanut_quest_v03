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


var current_health : int
 
var current_max_health : int = 3


var is_invul : bool
var is_being_hit : bool


var swing_combo_active : bool = false


var slide_blocking_attack : bool = false


var knockback_direction : Vector2


func _ready() -> void:
	player_is_attacking = false
	player_can_attack = true



func freeze_frame(time_scale: float, duration : float):
	Engine.time_scale = time_scale
	await get_tree().create_timer(duration * time_scale).timeout
	Engine.time_scale = 1.0
	
	

func player_invul(length : float):
	is_invul = true
	is_being_hit = true
	await get_tree().create_timer(length).timeout
	is_invul = false
	is_being_hit = false
	
	
	
	
	
