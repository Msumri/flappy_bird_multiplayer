extends MultiplayerSpawner
@export var bird_player:PackedScene
@export var pipe_player:PackedScene

@onready var select_your_role: CanvasLayer = %select_yourRole

# Called when the node enters the scene tree for the first time.
@rpc("call_local","any_peer")
func hide_selection_window():
	select_your_role.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func spawn_player(id:int):
	if !multiplayer.is_server():return
	
	var player:=bird_player.instantiate()
	player.name=str(id)
	player.set_multiplayer_authority(id)
	get_node(spawn_path).call_deferred("add_child",player)
	hide_selection_window.rpc()

func spawn_pipe(id:int):
	if !multiplayer.is_server():return
	
	var player:=pipe_player.instantiate()
	player.name=str(id)
	player.set_multiplayer_authority(id)
	get_node(spawn_path).call_deferred("add_child",player)
	hide_selection_window.rpc()
	
func _on_bird_pressed() -> void:
	spawn_player(1)
	for id in multiplayer.get_peers():
		spawn_pipe(id)

func _on_pip_pressed() -> void:
	spawn_pipe(1)
	for id in multiplayer.get_peers():
		spawn_player(id)
