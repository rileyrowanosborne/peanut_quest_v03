extends TextureProgressBar


@onready var slow_timer: Timer = $SlowTimer


func _ready() -> void:
	GlobalSignalBus.connect("slow_down_start", start_slow_bar)
	

func _process(delta: float) -> void:
	
	value = slow_timer.time_left
	


func start_slow_bar():
		slow_timer.start(GameState.current_slow_down_length * GameState.current_slow_down_power)
		max_value = slow_timer.time_left
	
