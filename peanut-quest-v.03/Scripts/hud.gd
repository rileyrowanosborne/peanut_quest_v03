extends CanvasLayer



@onready var hud_crack: AnimatedSprite2D = $HudCrack



func _ready() -> void:
	show()
	GlobalSignalBus.connect("health_check", health_check)
	health_check()



func health_check():
	print(GameState.current_health)
	crack()



func crack():
	if GameState.current_health >= 2:
		hud_crack.play("NormalHealth")
	elif GameState.current_health == 2:
		hud_crack.play("LowHealth")
	elif GameState.current_health == 1:
		hud_crack.play("CriticalHealth")
	else:
		hud_crack.play("Crunch")
	
	
	
	
	
