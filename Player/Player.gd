#Zelda.csproj ma zmieniony target framework z .net 6 na 7
#animation tree: playmode travel
#transitions: switch mode immediate, mode enabled
extends CharacterBody2D

var playerVelocity: Vector2 = Vector2.ZERO
#@export wyswietla zmienna w inspectorze
@export var MAXSPEED: int = 100
@export var ACCELERATION: int = 500
@export var FRICTION: int = 500
@export var ROLLSPEED: int = 180
enum{
	MOVE,
	ATTACK,
	ROLL
}
var state := MOVE
var rollVector: Vector2 = Vector2.LEFT
#@onready jest mniej wiecej takie samo jak func _ready() ale odpala sie przed _ready() +
#@onready jest tylko do zmiennych, w _ready() mozna wpakowac wszystko +
#@onready is limited to expressions, _ready() can have statements
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var animationTree: AnimationTree = $AnimationTree
@onready var animationState: Variant = animationTree.get("parameters/playback")
@onready var swordHitbox: Area2D = $HitboxPivot/SwordHitbox
var stats: Node = PlayerStats

func _ready() -> void:
	var callable: Callable = Callable(self, "_on_player_stats_no_health")
	stats.connect("no_health", func(): queue_free())
	
	animationTree.active = true
	swordHitbox.knockbackVector = rollVector

func _physics_process(delta: float) -> void:
	match state:
		MOVE:
			moveState(delta)
		ATTACK:
			attackState(delta)
		ROLL:
			rollState(delta)

func moveState(delta: float) -> void:
	var inputVector: Vector2 = Vector2.ZERO
	inputVector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	inputVector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	inputVector = inputVector.normalized()

	if(inputVector != Vector2.ZERO):
		rollVector = inputVector
		swordHitbox.knockbackVector = inputVector
		animationTree.set("parameters/Idle/blend_position", inputVector)
		animationTree.set("parameters/Run/blend_position", inputVector)
		animationTree.set("parameters/Attack/blend_position", inputVector)
		animationTree.set("parameters/Roll/blend_position", inputVector)
		animationState.travel("Run")
		playerVelocity = playerVelocity.move_toward(inputVector * MAXSPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		playerVelocity = playerVelocity.move_toward(Vector2.ZERO, FRICTION * delta)

	velocity = playerVelocity
	move_and_slide()
	
	if(Input.is_action_just_pressed("attack")):
		state = ATTACK
	elif(Input.is_action_just_pressed("roll")):
		state = ROLL

#jak delta jest nieuzywana to dodajemy _ zeby nie bylo warninga
func attackState(_delta: float) -> void:
	#playerVelocity = Vector2.ZERO
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func resetState() -> void:
	velocity = velocity / 2
	state = MOVE

func rollState(_delta: float) -> void:
	velocity = rollVector * ROLLSPEED
	animationState.travel("Roll")
	move_and_slide()

func _on_hurtbox_area_entered(_area: Area2D) -> void:
	stats.health -= 1
	print(stats.health)

func _on_player_stats_no_health(_area: Area2D) -> void:
	print("bleh")
	queue_free()
