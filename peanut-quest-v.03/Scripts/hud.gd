extends CanvasLayer



@onready var peanut_texture: TextureRect = $HealthBar/PeanutTexture
@onready var peanut_texture_2: TextureRect = $HealthBar/PeanutTexture2
@onready var peanut_texture_3: TextureRect = $HealthBar/PeanutTexture3
@onready var peanut_texture_4: TextureRect = $HealthBar/PeanutTexture4
@onready var peanut_texture_5: TextureRect = $HealthBar/PeanutTexture5

@onready var hud_crack: AnimatedSprite2D = $HudCrack



func _ready() -> void:
	show()
	GlobalSignalBus.connect("health_check", health_check)
	health_check()



func health_check():
	print(GameState.current_health)
	hide_peanuts()
	
	if GameState.current_health == 0:
		hide_peanuts()
	if GameState.current_health >= 1:
		peanut_texture.show()
	if GameState.current_health >= 2:
		peanut_texture_2.show()
	if  GameState.current_health >= 3:
		peanut_texture_3.show()
	if GameState.current_health >= 4:
		peanut_texture_4.show()
	if  GameState.current_health >= 5:
		peanut_texture_5.show()
	
	
	crack()


func hide_peanuts():
	peanut_texture.hide()
	peanut_texture_2.hide()
	peanut_texture_3.hide()
	peanut_texture_4.hide()
	peanut_texture_5.hide()


func crack():
	if GameState.current_health > 2:
		hud_crack.play("NormalHealth")
	elif GameState.current_health == 2:
		hud_crack.play("LowHealth")
	elif GameState.current_health == 1:
		hud_crack.play("CriticalHealth")
	else:
		hud_crack.play("Crunch")
	
	
	
	
	
