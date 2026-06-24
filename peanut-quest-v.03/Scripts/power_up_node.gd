extends Node2D


@onready var power_up_anims_back: AnimatedSprite2D = $PowerUpAnimsBack
@onready var power_up_anims_front: AnimatedSprite2D = $PowerUpAnimsFront




const CLASSES = {
	0: "Peanut",
	0.5: "Critical Peanut",
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
	GlobalSignalBus.connect("knight_activate", spawn_sword)
	GlobalSignalBus.connect("knight_deactivate", despawn_sword)
	
	GlobalSignalBus.connect("monk_activate", spawn_monk)
	GlobalSignalBus.connect("monk_deactivate", despawn_monk)
	
	GlobalSignalBus.connect("mage_activate", spawn_mage)
	GlobalSignalBus.connect("mage_deactivate", despawn_mage)
	
	GlobalSignalBus.connect("slime_activate", spawn_slime)
	GlobalSignalBus.connect("slime_deactivate", despawn_slime)
	
	GlobalSignalBus.connect("level_up", level_up)
	
	GlobalSignalBus.connect("class_update", class_update)
	

	
func class_update():
	
	GameState.current_class = CLASSES[GameState.class_mask]
	
	GlobalSignalBus.emit_signal("ability_update")
	


func level_up():
	pass



func spawn_monk():
	front_anims_player("Yellow")
	back_anims_player("Yellow")
	

func despawn_monk():
	if GameState.monk_is_active:
		GameState.monk_is_active = false


func spawn_slime():
	front_anims_player("Green")
	back_anims_player("Green")
	

func despawn_slime():
	if GameState.slime_is_active:
		GameState.slime_is_active = false


func spawn_mage():
	front_anims_player("Red")
	back_anims_player("Red")
	

func despawn_mage():
	if GameState.mage_is_active:
		GameState.mage_is_active = false


func spawn_sword():
	front_anims_player("Blue")
	back_anims_player("Blue")


func despawn_sword():
	if GameState.knight_is_active:
		GameState.knight_is_active = false



func back_anims_player(anim : String):
	power_up_anims_back.play(anim)


func front_anims_player(anim : String):
	power_up_anims_front.play(anim)
