extends Control


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var rich_text_label: RichTextLabel = $RichTextLabel



var rude_frog_dialogue = {
	option00 = "",
	option01 = "Uhhmm excuse me... what are you doing down here? 
	I would actually really appreciate an explanation.",
	option02 = "Oh ok, so you are a peanut. Awesome dude... that clarifies nothing.",
	option03 = "Oh ok, so you fell from really high up? BORINGGGG.",
	option04 = "Like who cares man- WAIT, FROM A CASTLE? Gosh not Baltrude's castle I hope...",
	option05 = "That guy is bad news. Mama Mia is he bad news. My mother always says this: 'Man, I really hate that guy.'",
	option06 = "Wait, actually, you know what? That plant back there is a peanut bush. But it has something wrong with it.",
	option07 = "According to like every scientific journal I have read, peanuts grow in the ground, like what kind of weird baloney is that.",
	option08 = "Did you know this about yourself? That you come from the ground,",
	option09 = "sorta like a potato...",
	option10 = "Also bit of a peanut fact here, peanuts have inherent agility from birth, but life sort of drains it out of them relativley quick and thats why they don't move much.",
	option11 = "Did you know that? You must be a bright little fellow. You should try using your dash button. I believe that, according to my calculations, you are gonna wanna press the left trigger...",
	option12 = "What does that even mean, huh...",
	option13 = "Oh? Who am I? I'm Froggy no.1023452, I'm part of the hive, if you know what I mean.",
	option14 = "You know what keep your questions to your self actually.",
	option15 = "no, no, no man, respect my boundaries, LISTEN dude. DUDE, LIKE DAMN! GET OUT OF HERE, WEIRDO!",
	option16 = "GOSH! GET YOUR OWN SLIME-WATCHIN' SPOT! nobody wants to work for anything anymore SHEESH"
}

var apathetic_frog = {
	option00 = "",
	option01 = "",
	option02 = "",
	option03 = "",
	option04 = "",
	option05 = "",
	option06 = "",
	option07 = "",
	option08 = "",
	option09 = "",
	option10 = "",
	option11 = "",
	
}

var forest_hand_options = {
	option00 = "",
	option01 = "Oh you beautiful little creature... Where are you going?",
	option02 = "You seems so confused and distraught, how can I help you?",
	option03 = "Well without knowing how to help I cannot help. Oh you poor little thing.",
	option04 = "Oh yes I know all about them. Do make sure to ignore them at every opportunity.",
	option05 = "Yes, yes. The hive this, the hive that. Bleh bleh bleh.",
	option06 = "",
	option07 = "",
	option08 = "",
	option09 = "",
	option10 = "",
	option11 = "",
	option12 = "",
	
}

var spider_options = {
	option00 = "",
	option01 = "Good evening my tiny little friend.",
	option02 = "",
	option03 = "",
	option04 = "",
	option05 = "",
	option06 = "",
	option07 = "",
	option08 = "",
	option09 = "",
	option10 = "",
	option11 = "",
	
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	GlobalSignalBus.connect("dialogue_sprite_update", dialogue_sprite_update)
	GlobalSignalBus.connect("rude_frog_dialogue", rude_frog_update)
	GlobalSignalBus.connect("forest_hand_dialogue", forest_hand_dialogue)
	GlobalSignalBus.connect("spider_dialogue", spider_dialogue)
	GlobalSignalBus.connect("begin_dialogue", begin_dialogue)
	GlobalSignalBus.connect("end_dialogue", end_dialogue)

func begin_dialogue():
	show()

func rude_frog_update():
	
	GameState.current_dialogue = "rude_frog_dialogue"
	
	if Input.is_action_just_pressed("interact"):
		if GameState.current_dialogue_progress == 1:
			rich_text_label.text = rude_frog_dialogue.option01
		elif GameState.current_dialogue_progress == 2:
			rich_text_label.text = rude_frog_dialogue.option02
		elif GameState.current_dialogue_progress == 3:
			rich_text_label.text = rude_frog_dialogue.option03
		elif GameState.current_dialogue_progress == 4:
			rich_text_label.text = rude_frog_dialogue.option04
		elif GameState.current_dialogue_progress == 5:
			rich_text_label.text = rude_frog_dialogue.option05
		elif GameState.current_dialogue_progress == 6:
			rich_text_label.text = rude_frog_dialogue.option06
		elif GameState.current_dialogue_progress == 7:
			rich_text_label.text = rude_frog_dialogue.option07
		elif GameState.current_dialogue_progress == 8:
			rich_text_label.text = rude_frog_dialogue.option08
		elif GameState.current_dialogue_progress == 9:
			rich_text_label.text = rude_frog_dialogue.option09
		elif GameState.current_dialogue_progress == 10:
			rich_text_label.text = rude_frog_dialogue.option10
		elif GameState.current_dialogue_progress == 11:
			rich_text_label.text = rude_frog_dialogue.option11
		elif GameState.current_dialogue_progress == 12:
			rich_text_label.text = rude_frog_dialogue.option12
		elif GameState.current_dialogue_progress == 13:
			rich_text_label.text = rude_frog_dialogue.option13
		elif GameState.current_dialogue_progress == 14:
			rich_text_label.text = rude_frog_dialogue.option14
		elif GameState.current_dialogue_progress == 15:
			rich_text_label.text = rude_frog_dialogue.option15
		elif GameState.current_dialogue_progress == 16:
			rich_text_label.text = rude_frog_dialogue.option16

func forest_hand_dialogue():
	GameState.current_dialogue = "forest_hand_dialogue"
	
	if Input.is_action_just_pressed("interact"):
		if GameState.current_dialogue_progress == 1:
			rich_text_label.text = forest_hand_options.option01
		elif GameState.current_dialogue_progress == 2:
			rich_text_label.text = forest_hand_options.option02
		elif GameState.current_dialogue_progress == 3:
			rich_text_label.text = forest_hand_options.option03
		elif GameState.current_dialogue_progress == 4:
			rich_text_label.text = forest_hand_options.option04
		elif GameState.current_dialogue_progress == 5:
			rich_text_label.text = forest_hand_options.option05
		elif GameState.current_dialogue_progress == 6:
			rich_text_label.text = forest_hand_options.option06
		elif GameState.current_dialogue_progress == 7:
			rich_text_label.text = forest_hand_options.option07


func spider_dialogue():
	GameState.current_dialogue = "spider_dialogue"
	
	if Input.is_action_just_pressed("interact"):
		if GameState.current_dialogue_progress == 1:
			rich_text_label.text = spider_options.option01
		elif GameState.current_dialogue_progress == 2:
			rich_text_label.text = spider_options.option02
		elif GameState.current_dialogue_progress == 3:
			rich_text_label.text = spider_options.option03
		elif GameState.current_dialogue_progress == 4:
			rich_text_label.text = spider_options.option04
		elif GameState.current_dialogue_progress == 5:
			rich_text_label.text = spider_options.option05
		elif GameState.current_dialogue_progress == 6:
			rich_text_label.text = spider_options.option06
		elif GameState.current_dialogue_progress == 7:
			rich_text_label.text = spider_options.option07


func dialogue_sprite_update():
	if GameState.current_dialogue == "rude_frog_dialogue":
		animated_sprite_2d.play("FrogTalking")
	
	if GameState.current_dialogue == "forest_hand_dialogue":
		animated_sprite_2d.play("HandTalking")
	
	if GameState.current_dialogue == "spider_dialogue":
		animated_sprite_2d.play("SpiderTalking")

func end_dialogue():
	hide()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "FrogTalking":
		animated_sprite_2d.play("FrogIdle")
	elif animated_sprite_2d.animation == "HandTalking":
		animated_sprite_2d.play("HandIdle")
	elif animated_sprite_2d.animation == "SpiderTalking":
		animated_sprite_2d.play("SpiderIdle")
