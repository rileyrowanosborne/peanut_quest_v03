extends CanvasLayer



@onready var hud_crack: AnimatedSprite2D = $HudCrack
@onready var special_progress_bar: TextureProgressBar = $SpecialProgressBar

@onready var special_progress_bar_2: TextureProgressBar = $SpecialProgressBar2

@onready var salt_progress_bar: TextureProgressBar = $SaltProgressBar

@onready var class_text: RichTextLabel = $Currency/ClassText


const SPRITES = {
	0: "Peanut",
	0.5: "Naked Peanut",
	1: "Monk",
	2: "Slime",
	4: "Mage",
	8: "Knight",
	3: "Necromancer",
	5: "Sorceror",
	9: "Paladin",
	6: "Liquid Wizard",
	10: "Armored Goop",
	12: "Warlock",

	7: "Toxic Deluge",
	11: "Crest Fallen",
	13: "Holy Warrior",
	14: "Mimic",

	15: "Mega Peanut",
	}

func _ready() -> void:
	show()
	GlobalSignalBus.connect("health_check", health_check)
	GlobalSignalBus.connect("essence_update", special_bar_update)
	GlobalSignalBus.connect("salt_update", salt_bar_update)
	GlobalSignalBus.connect("class_update", class_type)
	
	health_check()
	class_type()


func class_type():
	class_text.show()
	
	class_text.text = SPRITES[GameState.class_mask]
	
	await get_tree().create_timer(1).timeout
	class_text.hide()



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
	
	
	
	
	
