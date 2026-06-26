extends CharacterBody2D


@onready var spawn_timer: Timer = $SpawnTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


@export var grub_scene : PackedScene

@export var grub_spawn_delay : float = 3


var current_direction : Vector2 = Vector2(-1,0)


var current_health : int = 5


func _ready() -> void:
	add_to_group("enemy")
	spawn_timer.start(grub_spawn_delay)




func spawn_grub(world_location : Vector2):
	if grub_scene:
		var grub_instance = grub_scene.instantiate()
		get_tree().current_scene.call_deferred("add_child", grub_instance)
		grub_instance.global_position = world_location
		grub_instance.direction = current_direction


func _on_spawn_timer_timeout() -> void:
	spawn_grub(global_position)
	spawn_timer.start(grub_spawn_delay)


func take_damage(knockback_dir : Vector2):
	animated_sprite_2d.play("Hurt")
	current_health -= 1
	health_check()

func health_check():
	if current_health <= 0:
		die()

func die():
	queue_free()


func _on_animated_sprite_2d_animation_finished() -> void:
	animated_sprite_2d.play("Idle")
