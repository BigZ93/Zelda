extends Area2D

const hitEffectScene: PackedScene = preload("res://Effects/hit_effect.tscn")
@export var showHit: bool = true

func _on_area_entered(area: Area2D) -> void:
	if(showHit):
		var hitEffectInstance: Node = hitEffectScene.instantiate()
		var worldNode: Node = get_tree().current_scene
		worldNode.add_child(hitEffectInstance)
		hitEffectInstance.global_position = self.global_position
