extends AnimatedSprite2D





const CRITICAL_SHELLED_PEANUT = preload("uid://conjsqldubh0o")
const HEALTHY_SHELLED_PEANUT = preload("uid://dgqsh7lws08ks")

const CRITICAL_SHELLED_PEANUT_CHARGED = preload("uid://bmjj5wng2vag")
const HEALTHY_SHELLED_PEANUT_CHARGED = preload("uid://dtysk3w4e4cr2")


const ARMORED_SHELLED_PEANUT_TEST = preload("uid://b3s3iomyn3v1k")
const ATHLETIC_SHELLED_PEANUT_TEST = preload("uid://bucgxyruopfwl")

@onready var poof: CPUParticles2D = $"../Particles/Poof"



func _ready() -> void:
	GlobalSignalBus.connect("health_check", anims_update)
	GlobalSignalBus.connect("crystal_activate", athletic_skin)
	GlobalSignalBus.connect("sword_activate", armor_skin)



func anims_update():
	poof.emitting = true
	if GameState.current_health == 1:
			sprite_frames = CRITICAL_SHELLED_PEANUT
		
	elif GameState.current_health == 2:
		sprite_frames = HEALTHY_SHELLED_PEANUT

		

		
	
func athletic_skin():
	poof.emitting = true
	sprite_frames = ATHLETIC_SHELLED_PEANUT_TEST

func armor_skin():
	poof.emitting = true
	sprite_frames = ARMORED_SHELLED_PEANUT_TEST
