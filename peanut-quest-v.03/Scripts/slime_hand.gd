extends Node2D


@onready var projectile_cooldown_timer: Timer = $Pivot/ProjectileCooldownTimer


@export var projectile_scene : PackedScene



var is_active = false

var can_attack : bool = true



func _ready() -> void:
	GlobalSignalBus.connect("ability_update", class_update)
	GlobalSignalBus.connect("slime_deactivate", despawn_hand)


func spawn_projectile(world_location : Vector2):
	if projectile_scene:
			var projectile_instance = projectile_scene.instantiate()
			get_tree().current_scene.call_deferred("add_child", projectile_instance)
			projectile_instance.global_position = world_location
			


func _on_projectile_cooldown_timer_timeout() -> void:
	can_attack = true




func class_update():
	if GameState.current_class == "Slime":
		is_active = true
	else:
		is_active = false


func _input(event: InputEvent) -> void:
	if is_active:
		if event.is_action_pressed("action"):
			if can_attack:
				can_attack = false
				spawn_projectile(global_position)
				projectile_cooldown_timer.start(GameState.current_slime_delay)
				
	


func despawn_hand():
	is_active = false
