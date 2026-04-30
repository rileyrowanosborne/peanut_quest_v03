extends Node2D




@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"



@onready var slash_area_left: Area2D = $"../Swings/SwingLeft/SlashAreaLeft"
@onready var swing_left_anim: AnimatedSprite2D = $"../Swings/SwingLeft/SwingLeftAnim"
@onready var slash_area_right: Area2D = $"../Swings/SwingRight/SlashAreaRight"
@onready var swing_right_anim: AnimatedSprite2D = $"../Swings/SwingRight/SwingRightAnim"

@onready var swing_air_anim: AnimatedSprite2D = $"../Swings/SwingAir/SwingAirAnim"
@onready var swing_air_anim_2: AnimatedSprite2D = $"../Swings/SwingAir/SwingAirAnim2"
@onready var swing_air_anim_3: AnimatedSprite2D = $"../Swings/SwingAir/SwingAirAnim3"
@onready var slash_area_air: Area2D = $"../Swings/SwingAir/SlashAreaAir"



@onready var swing_delay_timer: Timer = $SwingDelayTimer

@onready var sword_particles_1: CPUParticles2D = $SwordParticles1


enum sword_state {
	l_idle,
	l_walk,
	l_slide,
	l_attack,
	l_air,
	r_idle,
	r_walk,
	r_slide,
	r_attack,
	r_air,
	air_neutral,
	air_attack,
	wall_slide
}


var current_state : sword_state



func _ready() -> void:
	current_state = sword_state.l_idle



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("swing") and GameState.player_can_attack:
		
		
		if not GameState.player_is_attacking:
			GameState.player_is_attacking = true
			swing_delay_timer.start(GameState.current_swing_delay)
			
			if GameState.player_is_on_ground:
				if GameState.last_dir < 0:
					current_state = sword_state.l_attack
					swing_left_anim.play("default")
				elif GameState.last_dir > 0:
					current_state = sword_state.r_attack
					swing_right_anim.play("default")
			else:
				current_state = sword_state.air_attack
				swing_air_anim.play("default")
				swing_air_anim_2.play("default")
				swing_air_anim_3.play("default")
		


func _process(delta: float) -> void:
	
	
	match current_state:
		sword_state.l_idle:
			animation_player.play("IdleLeft")
			sword_particles_1.emitting = false
		
		sword_state.l_walk:
			animation_player.play("WalkLeft")
			if GameState.player_is_on_ground:
				sword_particles_1.emitting = true
			else:
				sword_particles_1.emitting = false
		
		sword_state.l_slide:
			animation_player.play("DashLeft")
			if GameState.player_is_on_ground:
				sword_particles_1.emitting = true
			else:
				sword_particles_1.emitting = false
		
		sword_state.l_attack:
			animation_player.play("AttackLeft")
			sword_particles_1.emitting = false
		
		sword_state.r_idle:
			animation_player.play("IdleRight")
			sword_particles_1.emitting = false
		
		sword_state.r_walk:
			animation_player.play("WalkRight")
			if GameState.player_is_on_ground:
				sword_particles_1.emitting = true
			else:
				sword_particles_1.emitting = false
		
		sword_state.r_slide:
			animation_player.play("DashRight")
			if GameState.player_is_on_ground:
				sword_particles_1.emitting = true
			else:
				sword_particles_1.emitting = false
			
		sword_state.r_attack:
			animation_player.play("AttackRight")
			sword_particles_1.emitting = false
		
		sword_state.air_attack:
			animation_player.play("AirAttack")
			sword_particles_1.emitting = false
		
		sword_state.wall_slide:
			animation_player.play("WallSlide")
			sword_particles_1.emitting = false
		
		sword_state.air_neutral:
			animation_player.play("AirNeutral")
			sword_particles_1.emitting = false
		
		sword_state.l_air:
			animation_player.play("AirLeft")
			sword_particles_1.emitting = false
		
		sword_state.r_air:
			animation_player.play("AirRight")
			sword_particles_1.emitting = false
	
	
	if not GameState.player_is_attacking:
		if GameState.player_is_wall_sliding:
			current_state = sword_state.wall_slide
			GameState.player_can_attack = false
		else:
			if GameState.player_is_on_ground:
				GameState.player_can_attack = true
				if GameState.player_direction != 0:
					if GameState.player_direction > 0:
						if GameState.player_is_sliding:
							current_state = sword_state.r_slide
							GameState.player_can_attack = false
						else:
							GameState.player_can_attack = true
							current_state = sword_state.r_walk
					elif  GameState.player_direction < 0:
						if GameState.player_is_sliding:
							current_state = sword_state.l_slide
						else:
							current_state = sword_state.l_walk
				else:
					if GameState.last_dir > 0:
						current_state = sword_state.r_idle
					elif GameState.last_dir < 0:
						current_state = sword_state.l_idle
			else:
				if GameState.player_direction == 0:
					current_state = sword_state.air_neutral
				else:
					if GameState.player_direction < 0:
						current_state = sword_state.l_air
					elif GameState.player_direction > 0:
						current_state = sword_state.r_air
		
	
	
	if swing_left_anim.is_playing():
		slash_area_left.monitoring = true
	else:
		slash_area_left.monitoring = false
	
	if swing_right_anim.is_playing():
		slash_area_right.monitoring = true
	else:
		slash_area_right.monitoring = false
	
	if swing_air_anim.is_playing():
		slash_area_air.monitoring = true
	else:
		slash_area_air.monitoring = false


func _on_swing_delay_timer_timeout() -> void:
	GameState.player_is_attacking = false
	if GameState.last_dir > 0:
		current_state = sword_state.r_idle
	elif  GameState.last_dir < 0:
		current_state = sword_state.l_idle
	
