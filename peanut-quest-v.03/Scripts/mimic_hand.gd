extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $Pivot/AnimatedSprite2D

@onready var pivot: Node2D = $Pivot
@onready var collision_shape_2d: CollisionShape2D = $Pivot/HitBox/CollisionShape2D



var is_active : bool = false

func _ready() -> void:
	GlobalSignalBus.connect("ability_update", class_update)


func _process(delta: float) -> void:
	
	if GameState.last_dir == -1:
		pivot.rotation_degrees = 180
	elif GameState.last_dir == 1:
		pivot.rotation_degrees = 0



func class_update():
	if GameState.current_class == "Mimic":
		is_active = true
	else:
		is_active = false
		

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		if is_active:
			attack()

func attack():
	animated_sprite_2d.play("default")
	collision_shape_2d.disabled = false


func _on_animated_sprite_2d_animation_finished() -> void:
	collision_shape_2d.disabled = true
