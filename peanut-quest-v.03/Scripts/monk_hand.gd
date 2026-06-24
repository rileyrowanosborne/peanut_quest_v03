extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $Pivot/AnimatedSprite2D

@onready var pivot: Node2D = $Pivot

@onready var collision_shape_2d: CollisionShape2D = $Pivot/Area2D/CollisionShape2D


var is_active : bool = false

func _ready() -> void:
	GlobalSignalBus.connect("ability_update", class_update)


func _process(delta: float) -> void:
	if is_active:
		if GameState.last_dir == -1:
			pivot.rotation_degrees = 180
		elif GameState.last_dir == 1:
			pivot.rotation_degrees = 0

		if animated_sprite_2d.is_playing():
			collision_shape_2d.disabled = false
		else:
			collision_shape_2d.disabled = true


func _input(event: InputEvent) -> void:
	
	if is_active:
		if event.is_action_pressed("action"):
			animated_sprite_2d.play("Swing")

func class_update():
	if GameState.current_class == "Monk":
		is_active = true
	else:
		is_active = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(pivot.global_position)
