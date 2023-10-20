extends CharacterBody2D

@export var enemyVelocity: Vector2 = Vector2.ZERO
@export var knockback: Vector2 = Vector2.ZERO
@export var FRICTION: int = 200
@export var ACCELERATION: int = 300
@export var MAXSPEED: int = 50
@onready var stats: Node = $Stats
@onready var playerDetectionZone: Area2D = $PlayerDetectionZone
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
const enemyEffectScene: PackedScene = preload("res://Effects/enemy_death_effect.tscn")
enum{
	IDLE,
	WANDER,
	CHASE
}
var state := CHASE

func _physics_process(delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	self.velocity = knockback
	move_and_slide()
	match state:
		IDLE:
			enemyVelocity = enemyVelocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seekPlayer()
		WANDER:
			pass
		CHASE:
			var player: Node2D = playerDetectionZone.player
			if(player != null):
				var playerDirection: Vector2 = (player.global_position - self.global_position).normalized()
				enemyVelocity = enemyVelocity.move_toward(playerDirection * MAXSPEED, ACCELERATION * delta)
			else:
				state = IDLE
			sprite.flip_h = enemyVelocity.x < 0
	self.velocity = enemyVelocity
	move_and_slide()

func seekPlayer() -> void:
	if(playerDetectionZone.canSeePlayer()):
		state = CHASE

func _on_hurtbox_area_entered(area: Area2D) -> void:
	var newHealth: int = stats.getHealth() - area.damage
	stats.setHealth(newHealth)
	knockback = area.knockbackVector * 120

func _on_stats_no_health() -> void:
	print("bleee")
	var enemyDeathInstance: Node = enemyEffectScene.instantiate()
	get_parent().add_child(enemyDeathInstance)
	enemyDeathInstance.global_position = self.global_position
	queue_free()
