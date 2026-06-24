extends Node2D


@onready var lights_pivot: Node2D = $LightsPivot


var is_active : bool = false


func _ready() -> void:
	lights_pivot.hide()
	GlobalSignalBus.connect("ability_update", class_update)




func _process(delta: float) -> void:
	lights_pivot.rotation_degrees += GameState.monk_rotation_amount * delta
	



func class_update():
	if GameState.current_class == "Sorceror":
		is_active = true
		lights_pivot.show()
	else:
		is_active = false
		lights_pivot.hide()
