extends CharacterBody2D
class_name  Bird
signal Gameover()
signal point()
const SPEED = 300.0
const JUMP_VELOCITY = -285.0
@onready var sprite_2d: AnimatedSprite2D = %Sprite2D
@export var playable:=false
@onready var wing: AudioStreamPlayer = $wing
func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	global_position=Vector2(55,321)

func _ready() -> void:
	sprite_2d.play("default")

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	#if !playable: return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		

	# Handle jump.
	if Input.is_action_just_pressed("lock"):
		velocity.y = JUMP_VELOCITY
		rotation=-45
		wing_flap.rpc()
	rotation=move_toward(rotation,90,0.03)
	move_and_slide()


func _on_hitbox_area_entered(area: Area2D) -> void:
	print("soemthing")
	if area.is_in_group("death"):
		Gameover.emit()
	elif area.is_in_group("point"):
		point.emit()
@rpc("any_peer","call_local")
func wing_flap():
	wing.play()
