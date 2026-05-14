extends CharacterBody2D


@onready var blood_spurt: Node2D = $BloodSpurt
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


@export var speed : float = 10.0
@export var blood_spurt_scene: PackedScene

var in_range : bool = false

var current_dir : Vector2


func _ready() -> void:
	add_to_group("enemy")
	current_dir = Vector2(randi_range(-1,1), randi_range(-1,1))
	await get_tree().create_timer(3).timeout
	change_direction()


func _physics_process(delta: float) -> void:
	
	velocity = current_dir * speed
	
	move_and_slide()

func _process(delta: float) -> void:
	if in_range:
		set_animation("InRange")
	else:
		set_animation("OutRange")


func change_direction():
	current_dir = Vector2(randi_range(-1,1), randi_range(-1,1))
	
	await get_tree().create_timer(3).timeout
	change_direction()



func take_damage(attack_dir : Vector2):
	
	
	var knockback_dir : Vector2 = (global_position - attack_dir).normalized()
	
	owner.current_health -= 1
	
	
	
	if owner.current_health <= 0:
		if blood_spurt.has_method("take_damage"):
			blood_spurt.take_damage()
		spawn_blood_spurt()
		animated_sprite_2d.hide()
		if owner.has_method("die"):
			owner.die()
		else:
			print("missing die function on emeny owner - message sent from floating enemy script")
			owner.queue_free()
	else:
		if blood_spurt.has_method("take_damage"):
			blood_spurt.take_damage()


func spawn_blood_spurt():
	if blood_spurt_scene:
		var spurt_instance = blood_spurt_scene.instantiate()
		get_tree().current_scene.add_child(spurt_instance)
		spurt_instance.global_position = global_position

func set_animation(anim : String):
	if animated_sprite_2d.animation != anim:
		animated_sprite_2d.play(anim)
