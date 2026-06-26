extends Node2D




@onready var swing_delay_timer: Timer = $SwingDelayTimer
@onready var axe_particles_1: CPUParticles2D = $AxeParticles1
@onready var combo_timer: Timer = $ComboTimer
@onready var swing_left_anim: AnimatedSprite2D = $"../Swings2/SwingLeftAnim"
@onready var stab_left_anim: AnimatedSprite2D = $"../Swings2/StabLeftAnim"
@onready var swing_left_anim_2: AnimatedSprite2D = $"../Swings2/SwingLeftAnim2"
@onready var swing_right_anim: AnimatedSprite2D = $"../Swings2/SwingRightAnim"
@onready var stab_right_anim: AnimatedSprite2D = $"../Swings2/StabRightAnim"
@onready var swing_right_anim_2: AnimatedSprite2D = $"../Swings2/SwingRightAnim2"
@onready var stab_air_anim: AnimatedSprite2D = $"../Swings2/StabAirAnim"
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var hit_box: Area2D = $"../HitBox"
@onready var collision_shape_2d: CollisionShape2D = $"../HitBox/CollisionShape2D"




var current_combo : int = 0

var crossfade_amount : float = 0

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
	GameState.player_can_attack = true
	current_state = sword_state.l_idle
	current_combo = 0



func _input(event: InputEvent) -> void:
	if get_parent().is_active:
		if event.is_action_pressed("action") and GameState.player_can_attack:
			swing_combo()


func swing_combo():
	
	GameState.player_can_attack = false
	swing_delay_timer.start(GameState.current_attack_delay)
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
	
	if get_parent().is_active:
		if GameState.last_dir == 1:
			hit_box.rotation_degrees = 180
		elif GameState.last_dir == -1:
			hit_box.rotation_degrees = 0
	
	
func state_machine():
	match current_state:
		sword_state.l_idle:
			animation_player.play("IdleLeft", crossfade_amount)
			axe_particles_1.emitting = false
			collision_shape_2d.disabled = true
		
		sword_state.l_walk:
			animation_player.play("WalkLeft", crossfade_amount)
			collision_shape_2d.disabled = true
			if GameState.player_is_on_ground:
				axe_particles_1.emitting = true
			else:
				axe_particles_1.emitting = false
		
		sword_state.l_slide:
			animation_player.play("DashLeft", crossfade_amount)
			collision_shape_2d.disabled = true
			if GameState.player_is_on_ground:
				axe_particles_1.emitting = true
			else:
				axe_particles_1.emitting = false
		
		sword_state.l_attack1:
			animation_player.play("AttackLeft1", crossfade_amount)
			axe_particles_1.emitting = false
			collision_shape_2d.disabled = false
			
			
		sword_state.l_attack2:
			animation_player.play("AttackLeft2", crossfade_amount)
			axe_particles_1.emitting = false
			collision_shape_2d.disabled = false
			
		sword_state.l_attack3:
			animation_player.play("AttackLeft3", crossfade_amount)
			axe_particles_1.emitting = false
			collision_shape_2d.disabled = false
		
		sword_state.r_idle:
			animation_player.play("IdleRight", crossfade_amount)
			axe_particles_1.emitting = false
			collision_shape_2d.disabled = true
		
		sword_state.r_walk:
			animation_player.play("WalkRight", crossfade_amount)
			collision_shape_2d.disabled = true
			if GameState.player_is_on_ground:
				axe_particles_1.emitting = true
			else:
				axe_particles_1.emitting = false
		
		sword_state.r_slide:
			animation_player.play("DashRight", crossfade_amount)
			collision_shape_2d.disabled = true
			if GameState.player_is_on_ground:
				axe_particles_1.emitting = true
			else:
				axe_particles_1.emitting = false
			
		sword_state.r_attack1:
			animation_player.play("AttackRight1", crossfade_amount)
			axe_particles_1.emitting = false
			collision_shape_2d.disabled = false
		
		sword_state.r_attack2:
			animation_player.play("AttackRight2", crossfade_amount)
			axe_particles_1.emitting = false
			collision_shape_2d.disabled = false
		
		sword_state.r_attack3:
			animation_player.play("AttackRight3", crossfade_amount)
			axe_particles_1.emitting = false
			collision_shape_2d.disabled = false
		
		sword_state.air_attack:
			animation_player.play("AirAttack", crossfade_amount)
			axe_particles_1.emitting = false
			collision_shape_2d.disabled = false

		
		sword_state.wall_slide:
			collision_shape_2d.disabled = true
			animation_player.play("WallSlide", crossfade_amount)
			axe_particles_1.emitting = false
		
		sword_state.air_neutral:
			collision_shape_2d.disabled = true
			animation_player.play("AirNeutral", crossfade_amount)
			axe_particles_1.emitting = false
		
		sword_state.l_air:
			collision_shape_2d.disabled = true
			animation_player.play("AirLeft", crossfade_amount)
			axe_particles_1.emitting = false
		
		sword_state.r_air:
			collision_shape_2d.disabled = true
			animation_player.play("AirRight", crossfade_amount)
			axe_particles_1.emitting = false
	

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
