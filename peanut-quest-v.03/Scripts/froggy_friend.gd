extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var emote: AnimatedSprite2D = $Emote



var in_range : bool = false



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		animated_sprite_2d.play("Idle-InRange")
		in_range = true
		emote.play("Question")
		emote.show()
		GameState.in_range_dialogue = true



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		animated_sprite_2d.play("Idle-OutRange")
		in_range = false
		emote.hide()
		GameState.in_range_dialogue = false
		GlobalSignalBus.emit_signal("dialogue_sprite_update")
		GameState.current_frog = 0


func _input(event: InputEvent) -> void:
	
	if in_range:
		if event.is_action_pressed("interact"):
			GameState.current_frog += 1
			animated_sprite_2d.play("Talking")
			emote.play("Surprise")
			GameState.current_dialogue = "FrogTalking"
			GlobalSignalBus.emit_signal("dialogue_sprite_update")
