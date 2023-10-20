extends AnimatedSprite2D

func _ready() -> void:
	var callable: Callable = Callable(self, "_on_animation_finished")
	self.connect("animation_finished", callable)
	frame = 0
	play("animation")

func _on_animation_finished() -> void:
	queue_free()
