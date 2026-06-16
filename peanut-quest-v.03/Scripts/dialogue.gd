extends Panel


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var rich_text_label: RichTextLabel = $RichTextLabel



var frog_dialogue = {
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
	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignalBus.connect("dialogue_sprite_update", dialogue_sprite_update)





func dialogue_sprite_update():
	
	if GameState.in_range_dialogue:
		show()
		if Input.is_action_just_pressed("interact"):
			if GameState.current_frog == 1:
				rich_text_label.text = frog_dialogue.option01
			elif GameState.current_frog == 2:
				rich_text_label.text = frog_dialogue.option02
			elif GameState.current_frog == 3:
				rich_text_label.text = frog_dialogue.option03
			elif GameState.current_frog == 4:
				rich_text_label.text = frog_dialogue.option04
			elif GameState.current_frog == 5:
				rich_text_label.text = frog_dialogue.option05
			elif GameState.current_frog == 6:
				rich_text_label.text = frog_dialogue.option06
			elif GameState.current_frog == 7:
				rich_text_label.text = frog_dialogue.option07
			elif GameState.current_frog == 8:
				rich_text_label.text = frog_dialogue.option08
			elif GameState.current_frog == 9:
				rich_text_label.text = frog_dialogue.option09
			elif GameState.current_frog == 10:
				rich_text_label.text = frog_dialogue.option10
			elif GameState.current_frog == 11:
				rich_text_label.text = frog_dialogue.option11
			elif GameState.current_frog == 12:
				rich_text_label.text = frog_dialogue.option12
			elif GameState.current_frog == 13:
				rich_text_label.text = frog_dialogue.option13
			elif GameState.current_frog == 14:
				rich_text_label.text = frog_dialogue.option14
			elif GameState.current_frog == 15:
				rich_text_label.text = frog_dialogue.option15
			elif GameState.current_frog == 16:
				rich_text_label.text = frog_dialogue.option16
	else:
		hide()
	
	
	if rich_text_label.text != frog_dialogue.option00:
		GameState.current_dialogue = "FrogTalking"
		animated_sprite_2d.play("FrogTalking")
	else:
		animated_sprite_2d.play("FrogIdle")
