extends Node2D

@onready var marker_2d: Marker2D = $Marker2D
@onready var fire_ball_cooldown_timer: Timer = $FireBallCooldownTimer

@export var fireball_scene : PackedScene

var can_attack : bool = true


func _ready() -> void:
	GlobalSignalBus.connect("mage_deactivate", despawn_hand)
	
	


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		if can_attack:
			can_attack = false
			spawn_fireball(marker_2d.global_position)
			fire_ball_cooldown_timer.start(GameState.current_attack_delay)


func despawn_hand():
	queue_free()



func spawn_fireball(world_location : Vector2):
	if fireball_scene:
			var fireball_instance = fireball_scene.instantiate()
			get_tree().current_scene.call_deferred("add_child", fireball_instance)
			fireball_instance.global_position = world_location
			if fireball_instance.has_method("direction_update"):
				fireball_instance.direction_update(GameState.last_dir)


func _on_fire_ball_cooldown_timer_timeout() -> void:
	can_attack = true
