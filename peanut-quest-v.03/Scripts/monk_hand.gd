extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $Pivot/AnimatedSprite2D

@onready var pivot: Node2D = $Pivot

@onready var collision_shape_2d: CollisionShape2D = $Pivot/Area2D/CollisionShape2D

@onready var holy_light_pivot: Node2D = $HolyLightPivot




func _ready() -> void:
	GlobalSignalBus.connect("monk_deactivate", despawn_hand)
	

func _process(delta: float) -> void:
	
	
	holy_light_pivot.rotation_degrees += GameState.monk_rotation_amount * delta
	
	if GameState.last_dir == -1:
		pivot.rotation_degrees = 180
	elif GameState.last_dir == 1:
		pivot.rotation_degrees = 0
	
	if animated_sprite_2d.is_playing():
		collision_shape_2d.disabled = false
	else:
		collision_shape_2d.disabled = true


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("action"):
		animated_sprite_2d.play("Swing")


func despawn_hand():
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(pivot.global_position)
