extends Node2D


@onready var blood_spurt: AnimatedSprite2D = $BloodSpurt


func _ready() -> void:
	blood_spurt.play("default")


func _on_blood_spurt_animation_finished() -> void:
	queue_free()
