#Zelda.csproj ma zmieniony target framework z .net 6 na 7
#animation tree: playmode travel
#transitions: switch mode immediate, mode enabled
extends CharacterBody2D

var playerVelocity: Vector2 = Vector2.ZERO
const MAXSPEED: int = 100
const ACCELERATION: int = 500
const FRICTION: int = 500

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var animationTree: AnimationTree = $AnimationTree
@onready var animationState: Variant = animationTree.get("parameters/playback")

func _ready() -> void:
	animationTree.active = true

func _physics_process(delta: float) -> void:
	var inputVector: Vector2 = Vector2.ZERO
	inputVector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	inputVector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	inputVector = inputVector.normalized()

	if(inputVector != Vector2.ZERO):
		animationTree.set("parameters/Idle/blend_position", inputVector)
		animationTree.set("parameters/Run/blend_position", inputVector)
		animationState.travel("Run")
		playerVelocity = playerVelocity.move_toward(inputVector * MAXSPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		playerVelocity = playerVelocity.move_toward(Vector2.ZERO, FRICTION * delta)

	velocity = playerVelocity

	move_and_slide()
