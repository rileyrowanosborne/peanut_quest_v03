extends Node2D

@onready var fire_ball_cooldown_timer: Timer = $Pivot/FireBallCooldownTimer

@export var fireball_scene : PackedScene


var can_attack : bool = true


var enemy_in_range : bool = false
var enemy_location : Vector2


var is_active = false

func _ready() -> void:
	GlobalSignalBus.connect("ability_update", class_update)
	GlobalSignalBus.connect("mage_deactivate", despawn_hand)


func class_update():
	if GameState.current_class == "Mage":
		is_active = true
	else:
		is_active = false


func _input(event: InputEvent) -> void:
	if is_active:
		if event.is_action_pressed("action"):
			if can_attack:
				can_attack = false
				spawn_fireball(global_position)
				fire_ball_cooldown_timer.start(GameState.current_fireball_delay)
				
	


func despawn_hand():
	is_active = false


func spawn_fireball(world_location : Vector2):
	if fireball_scene:
			var fireball_instance = fireball_scene.instantiate()
			get_tree().current_scene.call_deferred("add_child", fireball_instance)
			fireball_instance.global_position = world_location
			if enemy_in_range:
				if fireball_instance.has_method("target_update"):
					fireball_instance.target_update(enemy_location)
			else:
				if fireball_instance.has_method("default_target"):
					fireball_instance.default_target()
				if fireball_instance.has_method("direction_update"):
					fireball_instance.direction_update(GameState.last_dir)


func _on_fire_ball_cooldown_timer_timeout() -> void:
	can_attack = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemy_in_range = true
		enemy_location = body.global_position


func _on_area_2d_body_exited(body: Node2D) -> void:
	enemy_in_range = false
