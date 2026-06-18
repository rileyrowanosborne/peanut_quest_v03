extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var emote: AnimatedSprite2D = $Emote


@export var dialogue_type : String

var in_range : bool = false



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		animated_sprite_2d.play("Activate")
		in_range = true
		emote.play("Question")
		emote.show()
		GameState.in_range_dialogue = true
		GameState.current_dialogue = dialogue_type
		GlobalSignalBus.emit_signal("dialogue_sprite_update")



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		animated_sprite_2d.play_backwards("Activate")
		in_range = false
		emote.play("Question")
		emote.hide()
		GameState.in_range_dialogue = false
		GlobalSignalBus.emit_signal("end_dialogue")
		GameState.current_dialogue_progress = 0


func _input(event: InputEvent) -> void:
	
	if in_range:
		if event.is_action_pressed("interact"):
			GameState.current_dialogue_progress += 1
			animated_sprite_2d.play("Talking")
			emote.play("Surprise")
			GameState.current_dialogue = dialogue_type
			GlobalSignalBus.emit_signal(dialogue_type)
			GlobalSignalBus.emit_signal("begin_dialogue")
			GlobalSignalBus.emit_signal("dialogue_sprite_update")



func _on_animated_sprite_2d_animation_finished() -> void:
	if in_range:
		animated_sprite_2d.play("Idle")
	else:
		animated_sprite_2d.play("Hidden")
