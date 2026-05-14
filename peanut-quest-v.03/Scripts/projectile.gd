extends Area2D


var invul : bool = true

@onready var invul_timer: Timer = $InvulTimer

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var ray_cast_2d_2: RayCast2D = $RayCast2D2
@onready var ray_cast_2d_3: RayCast2D = $RayCast2D3
@onready var ray_cast_2d_4: RayCast2D = $RayCast2D4
@onready var ray_cast_2d_5: RayCast2D = $RayCast2D5
@onready var ray_cast_2d_6: RayCast2D = $RayCast2D6
@onready var ray_cast_2d_7: RayCast2D = $RayCast2D7
@onready var ray_cast_2d_8: RayCast2D = $RayCast2D8






func _ready() -> void:
	invul_timer.start()


func _process(delta: float) -> void:
	world_collision()




func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(global_position)
			get_parent().queue_free()


func world_collision():
	if invul_timer.is_stopped():
		if ray_cast_2d.is_colliding()\
		or ray_cast_2d_2.is_colliding()\
		or ray_cast_2d_3.is_colliding()\
		or ray_cast_2d_4.is_colliding()\
		or ray_cast_2d_5.is_colliding()\
		or ray_cast_2d_6.is_colliding()\
		or ray_cast_2d_7.is_colliding()\
		or ray_cast_2d_8.is_colliding():
			queue_free()


func _on_invul_timer_timeout() -> void:
	invul = false
