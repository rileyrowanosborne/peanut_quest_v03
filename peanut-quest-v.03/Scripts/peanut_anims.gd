extends AnimatedSprite2D





const CRITICAL_SHELLED_PEANUT = preload("uid://conjsqldubh0o")
const HEALTHY_SHELLED_PEANUT = preload("uid://dgqsh7lws08ks")

const CRITICAL_SHELLED_PEANUT_CHARGED = preload("uid://bmjj5wng2vag")
const HEALTHY_SHELLED_PEANUT_CHARGED = preload("uid://dtysk3w4e4cr2")


const ARMORED_SHELLED_PEANUT_TEST = preload("uid://b3s3iomyn3v1k")
const ATHLETIC_SHELLED_PEANUT_TEST = preload("uid://bucgxyruopfwl")
const MONK_SHELLED_PEANUT_TEST = preload("uid://bn1iw806stobj")
const MAGE_SHELLED_PEANUT_TEST = preload("uid://bc6d8tnp80iy")
const SLIME_SHELLED_PEANUT_TEST = preload("uid://bwknbmdrs6hpm")



@onready var poof: CPUParticles2D = $"../Particles/Poof"



func _ready() -> void:
	GlobalSignalBus.connect("health_check", anims_update)
	GlobalSignalBus.connect("monk_activate", monk_skin)
	GlobalSignalBus.connect("knight_activate", armor_skin)
	GlobalSignalBus.connect("mage_activate", mage_skin)
	GlobalSignalBus.connect("slime_activate", slime_skin)



func anims_update():
	#poof.emitting = true
	if GameState.current_health == 1:
			sprite_frames = CRITICAL_SHELLED_PEANUT
		
	elif GameState.current_health == 2:
		sprite_frames = HEALTHY_SHELLED_PEANUT

		



func monk_skin():
	#poof.emitting = true
	sprite_frames = MONK_SHELLED_PEANUT_TEST

func slime_skin():
	sprite_frames = SLIME_SHELLED_PEANUT_TEST

func mage_skin():
	#poof.emitting = true
	sprite_frames = MAGE_SHELLED_PEANUT_TEST


func armor_skin():
	#poof.emitting = true
	sprite_frames = ARMORED_SHELLED_PEANUT_TEST
