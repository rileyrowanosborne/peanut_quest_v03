extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var bling: AnimatedSprite2D = $Bling
@onready var bling_2: AnimatedSprite2D = $Bling2
@onready var bling_3: AnimatedSprite2D = $Bling3


var in_range : bool = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if GameState.current_health <= 0:
			in_range = true
			rich_text_label.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		if GameState.current_health <= 0:
			in_range = false
			rich_text_label.hide()



func _input(event: InputEvent) -> void:
	if in_range:
		if event.is_action_pressed("action"):
			in_range = false
			reshell()



func reshell():
	rich_text_label.hide()
	animated_sprite_2d.play("Active")
	GameState.current_health = GameState.current_max_health
	GlobalSignalBus.emit_signal("reshell_peanut")



func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "Active":
		bling.play("default")
		bling_2.play("default")
		bling_3.play("default")
		animated_sprite_2d.play("Idle")
		GlobalSignalBus.emit_signal("reshell_complete")
