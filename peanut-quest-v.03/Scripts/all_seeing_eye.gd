extends Node2D


@onready var pivot: Node2D = $Pivot

@onready var aiming_laser: RayCast2D = $Pivot/AimingLaser

var in_range : bool = false







func _process(delta: float) -> void:
	
	var player_location : Vector2 = Vector2(GameState.player_location.x, GameState.player_location.y - 7)
	
	
	if in_range:
		pivot.look_at(player_location)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = true
		aiming_laser.set_is_casting(true)
		



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = false
		aiming_laser.set_is_casting(false)
