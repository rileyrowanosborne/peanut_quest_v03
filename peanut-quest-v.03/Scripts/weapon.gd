extends Node2D




@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"


@onready var sword_collision: CollisionPolygon2D = $HitBox/SwordCollision

@onready var swing_left_anim: AnimatedSprite2D = $"../Swings/SwingLeftAnim"
@onready var stab_left_anim: AnimatedSprite2D = $"../Swings/StabLeftAnim"
@onready var swing_left_anim_2: AnimatedSprite2D = $"../Swings/SwingLeftAnim2"
@onready var swing_right_anim: AnimatedSprite2D = $"../Swings/SwingRightAnim"
@onready var stab_right_anim: AnimatedSprite2D = $"../Swings/StabRightAnim"
@onready var swing_right_anim_2: AnimatedSprite2D = $"../Swings/SwingRightAnim2"
@onready var stab_air_anim: AnimatedSprite2D = $"../Swings/StabAirAnim"


@onready var swing_delay_timer: Timer = $SwingDelayTimer
@onready var combo_timer: Timer = $ComboTimer

@onready var sword_particles_1: CPUParticles2D = $SwordParticles1


var current_combo : int = 0


enum sword_state {
	l_idle,
	l_walk,
	l_slide,
	l_attack1,
	l_attack2,
	l_attack3,
	l_air,
	r_idle,
	r_walk,
	r_slide,
	r_attack1,
	r_attack2,
	r_attack3,
	r_air,
	air_neutral,
	air_attack,
	wall_slide
}


var current_state : sword_state



func _ready() -> void:
	current_state = sword_state.l_idle
	current_combo = 0



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("swing") and GameState.player_can_attack:
		swing_combo()


func swing_combo():
	
	GameState.player_can_attack = false
	swing_delay_timer.start(GameState.current_swing_delay)
	GameState.player_is_attacking = true
	combo_timer.start()
	if GameState.player_is_on_ground:
		if GameState.last_dir < 0:
			if current_combo == 0:
				current_state = sword_state.l_attack1
				swing_left_anim.play("Slash")
			if current_combo == 1:
				current_state = sword_state.l_attack2
				stab_left_anim.play("Stab")
			if current_combo == 2:
				current_state = sword_state.l_attack3
				swing_left_anim_2.play("Slash")
				
			current_combo += 1
			current_combo = clamp(current_combo, 0, 2)

		if GameState.last_dir > 0:
			if current_combo == 0:
				current_state = sword_state.r_attack1
				swing_right_anim.play("Slash")
			if current_combo == 1:
				current_state = sword_state.r_attack2
				stab_right_anim.play("Stab")
			if current_combo == 2:
				current_state = sword_state.r_attack3
				swing_right_anim_2.play("Slash")
				
			current_combo += 1
			current_combo = clamp(current_combo, 0, 2)
	
	else:
		current_state = sword_state.air_attack
		stab_air_anim.play("Stab")


func _process(delta: float) -> void:
	
	state_machine()
	
	state_machine_logic()
	
	
func state_machine():
	match current_state:
		sword_state.l_idle:
			animation_player.play("IdleLeft")
			sword_particles_1.emitting = false
			sword_collision.disabled = true
		
		sword_state.l_walk:
			animation_player.play("WalkLeft")
			sword_collision.disabled = true
			if GameState.player_is_on_ground:
				sword_particles_1.emitting = true
			else:
				sword_particles_1.emitting = false
		
		sword_state.l_slide:
			animation_player.play("DashLeft")
			sword_collision.disabled = true
			if GameState.player_is_on_ground:
				sword_particles_1.emitting = true
			else:
				sword_particles_1.emitting = false
		
		sword_state.l_attack1:
			animation_player.play("AttackLeft1")
			sword_particles_1.emitting = false
			sword_collision.disabled = false
			
			
		sword_state.l_attack2:
			animation_player.play("AttackLeft2")
			sword_particles_1.emitting = false
			sword_collision.disabled = false
			
		sword_state.l_attack3:
			animation_player.play("AttackLeft3")
			sword_particles_1.emitting = false
			sword_collision.disabled = false
		
		sword_state.r_idle:
			animation_player.play("IdleRight")
			sword_particles_1.emitting = false
			sword_collision.disabled = true
		
		sword_state.r_walk:
			animation_player.play("WalkRight")
			sword_collision.disabled = true
			if GameState.player_is_on_ground:
				sword_particles_1.emitting = true
			else:
				sword_particles_1.emitting = false
		
		sword_state.r_slide:
			animation_player.play("DashRight")
			sword_collision.disabled = true
			if GameState.player_is_on_ground:
				sword_particles_1.emitting = true
			else:
				sword_particles_1.emitting = false
			
		sword_state.r_attack1:
			animation_player.play("AttackRight1")
			sword_particles_1.emitting = false
			sword_collision.disabled = false
		
		sword_state.r_attack2:
			animation_player.play("AttackRight2")
			sword_particles_1.emitting = false
			sword_collision.disabled = false
		
		sword_state.r_attack3:
			animation_player.play("AttackRight3")
			sword_particles_1.emitting = false
			sword_collision.disabled = false
		
		sword_state.air_attack:
			animation_player.play("AirAttack")
			sword_particles_1.emitting = false
			sword_collision.disabled = false

		
		sword_state.wall_slide:
			sword_collision.disabled = true
			animation_player.play("WallSlide")
			sword_particles_1.emitting = false
		
		sword_state.air_neutral:
			sword_collision.disabled = true
			animation_player.play("AirNeutral")
			sword_particles_1.emitting = false
		
		sword_state.l_air:
			sword_collision.disabled = true
			animation_player.play("AirLeft")
			sword_particles_1.emitting = false
		
		sword_state.r_air:
			sword_collision.disabled = true
			animation_player.play("AirRight")
			sword_particles_1.emitting = false
	

func state_machine_logic():
	if not GameState.player_is_attacking:
		if GameState.player_is_wall_sliding:
			current_state = sword_state.wall_slide
			GameState.player_can_attack = false
		else:
			GameState.player_can_attack = true
			if GameState.player_is_on_ground:
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
		
	


func _on_swing_delay_timer_timeout() -> void:
	GameState.player_can_attack = true
	GameState.player_is_attacking = false
	if GameState.player_direction > 0:
		current_state = sword_state.r_idle
	elif  GameState.player_direction < 0:
		current_state = sword_state.l_idle
	


func _on_combo_timer_timeout() -> void:
	current_combo = 0


func _on_swing_left_anim_2_animation_finished() -> void:
	current_combo = 0


func _on_swing_right_anim_2_animation_finished() -> void:
	current_combo = 0
