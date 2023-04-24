extends Label

onready var Player = get_parent()



func _physics_process(delta: float) -> void:
	var state = Player.current_state
	text = str(state)
