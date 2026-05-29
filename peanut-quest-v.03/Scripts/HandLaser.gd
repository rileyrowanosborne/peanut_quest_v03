extends RayCast2D

@onready var line_2d: Line2D = $Line2D

@export var color := Color.WHITE: set = set_color

@export var cast_speed := 7000.0
@export var max_length:= 1400.0


func _ready() -> void:
	set_color(color)
	set_is_casting(is_casting)
	
	line_2d.width = laser_width








func _physics_process(delta: float) -> void:
	
	target_position.x = move_toward(
		target_position.x, 
		max_length,
		cast_speed * delta
	)
	
	
	var target
	
	var laser_end_position := target_position
	force_raycast_update()
	
	if is_colliding():
		
		target = get_collider()
		#if target.has_method("take_damage"):
			#target.take_damage(owner.global_position)
		
		laser_end_position = to_local(get_collision_point())
	
	line_2d.points[1] = laser_end_position


@export var is_casting := false: set = set_is_casting


func set_is_casting(new_value : bool):
	if is_casting == new_value:
		return
	
	
	is_casting = new_value
	
	set_physics_process(is_casting)
	
	if not line_2d:
		return
	
	if is_casting:
		appear()
		
	else:
		target_position = Vector2.ZERO
		disappear()



func set_color(new_color: Color):
	color = new_color
	if line_2d == null:
		return
	line_2d.modulate = new_color

@export var laser_width := 2.0
@export var growth_time := .1

var tween : Tween = null




func appear():
	line_2d.visible = true
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(line_2d, "width", laser_width, growth_time * 2.0).from(0.0)
	

func disappear():
	if tween and tween.is_running():
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(line_2d,"width", 0.0, growth_time).from_current()
	tween.tween_callback(line_2d.hide)
