extends Node2D

onready var sprite= $AnimatedSprite


func _ready() -> void:
	sprite.play("Puff")

func _on_Timer_timeout() -> void:
	self.queue_free()
