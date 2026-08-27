extends AnimatedSprite2D


func _ready() -> void:
	play("poof")
	animation_finished.connect(queue_free)
