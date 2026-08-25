extends Area2D

signal hurt(damage: int)


func take_damage(damage: int):
	hurt.emit(damage)
