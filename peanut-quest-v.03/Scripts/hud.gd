extends CanvasLayer



@onready var hud_crack: AnimatedSprite2D = $HudCrack
@onready var special_progress_bar: TextureProgressBar = $SpecialProgressBar

@onready var special_progress_bar_2: TextureProgressBar = $SpecialProgressBar2

@onready var salt_progress_bar: TextureProgressBar = $SaltProgressBar


func _ready() -> void:
	show()
	GlobalSignalBus.connect("health_check", health_check)
	GlobalSignalBus.connect("essence_update", special_bar_update)
	GlobalSignalBus.connect("salt_update", salt_bar_update)
	health_check()



func health_check():
	print("current health = " + str(GameState.current_health))
	crack()


func special_bar_update():
	special_progress_bar_2.value = GameState.current_brain_essence
	

func salt_bar_update():
	salt_progress_bar.value = GameState.current_salt


func crack():
	if GameState.current_health >= 2:
		hud_crack.play("NormalHealth")
	elif GameState.current_health == 2:
		hud_crack.play("LowHealth")
	elif GameState.current_health == 1:
		hud_crack.play("CriticalHealth")
	else:
		hud_crack.play("Crunch")
	
	
	
	
	
