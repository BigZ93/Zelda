extends Node

@export var maxHealth: int = 1

@onready var health: int = maxHealth

signal no_health

func setHealth(value: int) -> void:
	health = value
	if(health <= 0):
		emit_signal("no_health")

func getHealth() -> int:
	return health
