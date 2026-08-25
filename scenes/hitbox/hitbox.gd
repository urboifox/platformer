extends Area2D

@export var damage = 1


func _on_area_entered(area: Area2D) -> void:
	if area.owner.has_method("take_damage"):
		area.owner.take_damage(damage, global_position)
