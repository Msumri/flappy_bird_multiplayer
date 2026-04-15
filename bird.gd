extends CharacterBody2D
class_name  Bird

const SPEED = 300.0
const JUMP_VELOCITY = -285.0
@onready var sprite_2d: AnimatedSprite2D = %Sprite2D
@export var playable:=false
func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	
func _ready() -> void:
	sprite_2d.play("default")
	print("PLAYER READY:", name)
	print("AUTHORITY:", get_multiplayer_authority())
	print("IS AUTH:", is_multiplayer_authority())

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	if !playable: return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		

	# Handle jump.
	if Input.is_action_just_pressed("lock"):
		velocity.y = JUMP_VELOCITY
		rotation=-45
	rotation=move_toward(rotation,90,0.03)
	move_and_slide()
