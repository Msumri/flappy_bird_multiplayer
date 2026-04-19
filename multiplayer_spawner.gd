extends MultiplayerSpawner

@export var network_player: PackedScene

@onready var select_roll: Label = %selectRoll

var bird
func _ready() -> void:
		get_tree().paused = true
		if !multiplayer.is_server():
			%selectRoll.text="Host will pick thier Roll!"
			%bird.disabled=true
			%pip.disabled=true
@rpc("call_local","any_peer")	
func spawn_player(id: int) -> void:
	#if !multiplayer.is_server(): return

	var player: Node = network_player.instantiate()
	
	player.name = str(id)
	player.set_multiplayer_authority(id)

	get_node(spawn_path).call_deferred("add_child", player)
	player.playable=true


@rpc("any_peer", "call_local")
func on_choice(id:int):
	hidethings.rpc()

	
	if id==1:
		call_deferred("spawn_player", 1)
	else:
		if !multiplayer.is_server():
			spawn_player.rpc(multiplayer.get_unique_id())

@rpc("any_peer","call_local")	
func hidethings():
	get_tree().paused = false
	%select_yourRole.hide()

func _on_pip_pressed() -> void:
	$"../pipe_genrator".set_team.rpc(false)
	on_choice.rpc(2)

func _on_bird_pressed() -> void:
	on_choice(1)
	$"../pipe_genrator".set_team(false)
