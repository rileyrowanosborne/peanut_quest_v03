extends Node2D



var player_location : Vector2




@onready var dust_rumble: CPUParticles2D = $DustRumble
@onready var dust_rumble_2: CPUParticles2D = $DustRumble2
@onready var dust_rumble_3: CPUParticles2D = $DustRumble3
@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	timer.start()

func _process(delta: float) -> void:
	if timer.time_left < .5:
		dust_rumble.emitting = true
		dust_rumble_2.emitting = true
		dust_rumble_3.emitting = true
	
	else:
		dust_rumble.emitting = false
		dust_rumble_2.emitting = false
		dust_rumble_3.emitting = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("take_spike_damage"):
			body.take_spike_damage()


func _on_timer_timeout() -> void:
	animation_player.play("Pierce")
	timer.start()
