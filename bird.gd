extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var sprite_2d: AnimatedSprite2D = %Sprite2D

func _ready() -> void:
	sprite_2d.play("default")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY
		rotation=-45
	rotation=move_toward(rotation,90,0.03)
	move_and_slide()
