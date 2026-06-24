extends AnimatedSprite2D




#completed
const CRITICAL_SPRITE = preload("uid://conjsqldubh0o")
const PEANUT_SPRITE = preload("uid://dgqsh7lws08ks")

#singles
const KNIGHT_SPRITE = preload("uid://b3s3iomyn3v1k")
const MONK_SPRITE = preload("uid://bn1iw806stobj")
const MAGE_SPRITE = preload("uid://bc6d8tnp80iy")
const SLIME_SPRITE = preload("uid://bwknbmdrs6hpm")

#doubles
const MONK_MAGE_SPRITE = preload("uid://drvhi28ghoryt")
const MONK_SLIME_SPRITE = preload("uid://c8vaek5kxqjum")
const MONK_KNIGHT_SPRITE = preload("uid://7qs80tyba1la")
const MAGE_KNIGHT_SPRITE = preload("uid://emlxox5myc7n")

#triples
const MONK_SLIME_MAGE_SPRITE = preload("uid://c1s0xsgx7x33h")
const SLIME_MAGE_KNIGHT_SPRITE = preload("uid://djgf0113p84cx")


#no sprite sheet yet
const SLIME_MAGE_SPRITE = preload("uid://dgqsh7lws08ks")
const SLIME_KNIGHT_SPRITE = preload("uid://dgqsh7lws08ks")

const MONK_SLIME_KNIGHT_SPRITE = preload("uid://dgqsh7lws08ks")
const MONK_MAGE_KNIGHT_SPRITE = preload("uid://dgqsh7lws08ks")


const MONK_SLIME_MAGE_KNIGHT_SPRITE = preload("uid://dgqsh7lws08ks")


const SPRITES = {
	0: PEANUT_SPRITE,
	0.5: CRITICAL_SPRITE,
	1: MONK_SPRITE,
	2: SLIME_SPRITE,
	4: MAGE_SPRITE,
	8: KNIGHT_SPRITE,
	3: MONK_SLIME_SPRITE,
	5: MONK_MAGE_SPRITE,
	9: MONK_KNIGHT_SPRITE,
	6: SLIME_MAGE_SPRITE,
	10: SLIME_KNIGHT_SPRITE,
	12: MAGE_KNIGHT_SPRITE,

	7: MONK_SLIME_MAGE_SPRITE,
	11: MONK_SLIME_KNIGHT_SPRITE,
	13: MONK_MAGE_KNIGHT_SPRITE,
	14: SLIME_MAGE_KNIGHT_SPRITE,

	15: MONK_SLIME_MAGE_KNIGHT_SPRITE,
	}


@onready var poof: CPUParticles2D = $"../Particles/Poof"



func _ready() -> void:

	GlobalSignalBus.connect("class_update", class_update)



func  sprite_update():
	sprite_frames = SPRITES[GameState.class_mask]
	



func class_update():
	
	GameState.class_mask = 0
	
	if GameState.monk_is_active:
		GameState.class_mask |= 1
	if GameState.slime_is_active:
		GameState.class_mask |= 2
	if GameState.mage_is_active:
		GameState.class_mask |= 4
	if GameState.knight_is_active:
		GameState.class_mask |= 8
	
	
	sprite_update()
