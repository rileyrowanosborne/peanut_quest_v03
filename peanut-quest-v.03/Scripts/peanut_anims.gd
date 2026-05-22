extends AnimatedSprite2D




const CRITICAL_SHELLED_PEANUT = preload("uid://conjsqldubh0o")
const HEALTHY_SHELLED_PEANUT = preload("uid://dgqsh7lws08ks")





func _ready() -> void:
	GlobalSignalBus.connect("health_check", anims_update)
	




func anims_update():
	if GameState.current_health == 2:
		sprite_frames = HEALTHY_SHELLED_PEANUT
	
	if GameState.current_health == 1:
		sprite_frames = CRITICAL_SHELLED_PEANUT
