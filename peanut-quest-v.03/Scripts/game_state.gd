extends Node

var player_direction : float
var last_dir : float = 1.0

var player_is_sliding  : bool

var player_is_on_ground : bool


var player_location : Vector2

var player_center_location : Vector2

var player_is_wall_sliding : bool

var player_is_attacking : bool
var player_can_attack : bool
var current_swing_delay : float = .4


var current_health : int
 
var current_max_health : int = 2


var is_invul : bool
var is_being_hit : bool


var swing_combo_active : bool = false


var slide_blocking_attack : bool = false


var knockback_direction : Vector2

var current_slow_down_power : float = .3
var current_slow_down_length : float = 5.0

var current_brain_essence : int = 0
var max_brain_essence : int = 10

var current_salt : int = 0
var max_salt: int = 10

var player_is_shelled : bool = true

var first_load : bool = true

var sword_is_active : bool = false

var slow_ability_unlocked : bool = false
var phase_ability_unlocked : bool = false
var goop_ability_unlocked : bool = false


func _ready() -> void:
	player_is_attacking = false
	player_can_attack = true
	slow_ability_unlocked = true



func freeze_frame(time_scale: float, duration : float):
	Engine.time_scale = time_scale
	await get_tree().create_timer(duration * time_scale).timeout
	Engine.time_scale = 1.0
	
	

func player_invul(length : float):
	is_invul = true
	#is_being_hit = true
	await get_tree().create_timer(length).timeout
	is_invul = false
	#is_being_hit = false
	
	

func _input(event: InputEvent) -> void:
	if slow_ability_unlocked:
		if event.is_action_pressed("special_l"):
			if current_salt >= 1:
				GlobalSignalBus.emit_signal("slow_down_start")
				freeze_frame(GameState.current_slow_down_power, GameState.current_slow_down_length)
				current_salt -= 1
				GlobalSignalBus.emit_signal("salt_update")
