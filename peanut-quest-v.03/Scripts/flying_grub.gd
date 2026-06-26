extends CharacterBody2D


@onready var flight_timer: Timer = $FlightTimer

var y_impulse : float = -200 

var speed : int = 50

var direction : Vector2 = Vector2(1,1)




func _ready() -> void:
	flight_timer.start()


func _physics_process(delta: float) -> void:
	
	velocity = speed * direction
	
	move_and_slide()


func _on_flight_timer_timeout() -> void:
	velocity.y = y_impulse
	
	flight_timer.start()
