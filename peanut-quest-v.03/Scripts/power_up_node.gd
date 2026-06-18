extends Node2D


@onready var power_up_anims_back: AnimatedSprite2D = $PowerUpAnimsBack
@onready var power_up_anims_front: AnimatedSprite2D = $PowerUpAnimsFront


@export var sword_scene : PackedScene
@export var mage_scene : PackedScene
@export var monk_scene : PackedScene
@export var slime_scene : PackedScene


var sword_instance
var mage_instance
var monk_instance
var slime_instance




func _ready() -> void:
	
	GlobalSignalBus.connect("knight_activate", spawn_sword)
	GlobalSignalBus.connect("knight_deactivate", despawn_sword)
	
	GlobalSignalBus.connect("monk_activate", spawn_monk)
	GlobalSignalBus.connect("monk_deactivate", despawn_monk)
	
	GlobalSignalBus.connect("mage_activate", spawn_mage)
	GlobalSignalBus.connect("mage_deactivate", despawn_mage)
	
	GlobalSignalBus.connect("slime_activate", spawn_slime)
	GlobalSignalBus.connect("slime_deactivate", despawn_slime)
	

func spawn_monk():
	front_anims_player("Yellow")
	back_anims_player("Yellow")
	
	
	if monk_instance == null:
		if monk_scene:
			monk_instance = monk_scene.instantiate()
			get_parent().add_child(monk_instance)

func despawn_monk():
	if GameState.monk_is_active:
		if monk_instance != null:
			monk_instance.queue_free()
		GameState.monk_is_active = false


func spawn_slime():
	front_anims_player("Green")
	back_anims_player("Green")
	
	
	if slime_instance == null:
		if slime_scene:
			slime_instance = slime_scene.instantiate()
			get_parent().add_child(slime_instance)

func despawn_slime():
	if GameState.slime_is_active:
		if slime_instance != null:
			slime_instance.queue_free()
		GameState.slime_is_active = false


func spawn_mage():
	front_anims_player("Red")
	back_anims_player("Red")
	
	if mage_instance == null:
		if mage_scene:
			mage_instance = mage_scene.instantiate()
			get_parent().call_deferred("add_child", mage_instance)

func despawn_mage():
	if GameState.mage_is_active:
		if mage_instance != null:
			mage_instance.queue_free()
		GameState.mage_is_active = false


func spawn_sword():
	front_anims_player("Blue")
	back_anims_player("Blue")
	
	if sword_instance == null:
		if sword_scene:
			sword_instance = sword_scene.instantiate()
			get_parent().add_child(sword_instance)

func despawn_sword():
	if GameState.knight_is_active:
		if sword_instance != null:
			sword_instance.queue_free()
		GameState.knight_is_active = false



func back_anims_player(anim : String):
	power_up_anims_back.play(anim)


func front_anims_player(anim : String):
	power_up_anims_front.play(anim)
