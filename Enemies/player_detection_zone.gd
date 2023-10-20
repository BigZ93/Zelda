extends Area2D

var player: Node2D = null

func canSeePlayer() -> bool:
	return player != null

func _on_body_entered(body: Node2D) -> void:
	player = body

func _on_body_exited(body: Node2D) -> void:
	player = null
