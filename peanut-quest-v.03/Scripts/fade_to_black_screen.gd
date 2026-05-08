extends CanvasLayer

@onready var fade_in: AnimationPlayer = $FadeIn


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show()
	fade_in.play("FadeIn")
	
