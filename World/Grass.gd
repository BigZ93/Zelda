extends Node2D

const grassEffectScene: PackedScene = preload("res://Effects/grass_effect.tscn")

func createGrassEffect() -> void:
	var grassEffectInstance: Node = grassEffectScene.instantiate()
	#var worldNode: Node = get_tree().current_scene
	#worldNode.add_child(grassEffectInstance)
	get_parent().add_child(grassEffectInstance)
	#gdy uzywamy parenta zamiast roota to mozna uzyc position zamiast global_position
	grassEffectInstance.global_position = self.global_position

func _on_hurtbox_area_entered(_area: Area2D) -> void:
	createGrassEffect()
	queue_free()
