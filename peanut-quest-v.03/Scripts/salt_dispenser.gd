extends Node2D



@onready var button_anims: AnimatedSprite2D = $Button/ButtonAnims
@onready var hand_anims: AnimatedSprite2D = $Hand/HandAnims
@onready var salt_spawn_point: Node2D = $SaltSpawnPoint
@onready var cooldown_timer: Timer = $CooldownTimer


@export var salt_scene: PackedScene


var is_on_cooldown : bool = false


func _on_button_area_2d_body_entered(body: Node2D) -> void:
	if not is_on_cooldown:
		is_on_cooldown = true
		
		button_anims.play("Active")
		hand_anims.play("Dispensing")
		
		await get_tree().create_timer(.5).timeout
		
		cooldown_timer.start()
		
		spawn_salt(salt_spawn_point.global_position)


func _on_button_area_2d_body_exited(body: Node2D) -> void:
	if is_on_cooldown:
		button_anims.play("Cooldown")
	else:
		button_anims.play("Ready")



func spawn_salt(world_location : Vector2):
	if salt_scene:
		var salt_instance = salt_scene.instantiate()
		get_tree().current_scene.add_child(salt_instance)
		salt_instance.global_position = world_location


func _on_cooldown_timer_timeout() -> void:
	button_anims.play("Ready")
	hand_anims.play("Idle")
	is_on_cooldown = false
