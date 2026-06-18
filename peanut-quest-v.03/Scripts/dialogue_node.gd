extends Node2D


@onready var emote: AnimatedSprite2D = $Emote



@export var dialogue_type : String

var in_range : bool = false



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = true
		emote.play("Question")
		emote.show()
		GameState.in_range_dialogue = true
		GameState.current_dialogue = dialogue_type
		GlobalSignalBus.emit_signal("dialogue_sprite_update")



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = false
		emote.hide()
		GameState.in_range_dialogue = false
		GlobalSignalBus.emit_signal("end_dialogue")
		GameState.current_dialogue_progress = 0


func _input(event: InputEvent) -> void:
	
	if in_range:
		if event.is_action_pressed("interact"):
			GameState.current_dialogue_progress += 1
			emote.play("Surprise")
			GameState.current_dialogue = dialogue_type
			GlobalSignalBus.emit_signal(dialogue_type)
			GlobalSignalBus.emit_signal("begin_dialogue")
			GlobalSignalBus.emit_signal("dialogue_sprite_update")
