#Zelda.csproj ma zmieniony target framework z .net 6 na 7
#animation tree: playmode travel
#transitions: mode auto, added conditions isRunning + isIdle to transitions
extends CharacterBody2D

@export var speed: float = 100

@onready var animationTree: AnimationTree = $AnimationTree

var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	animationTree.active = true

func _process(delta: float):
	updateAnimationParameters()

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down").normalized()
	if(direction):
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

func updateAnimationParameters() -> void:
	if(velocity == Vector2.ZERO):
		animationTree["parameters/conditions/isIdle"] = true
		animationTree["parameters/conditions/isRunning"] = false
	else:
		animationTree["parameters/conditions/isIdle"] = false
		animationTree["parameters/conditions/isRunning"] = true
	if(direction != Vector2.ZERO):
		animationTree["parameters/Idle/blend_position"] = direction
		animationTree["parameters/Run/blend_position"] = direction
