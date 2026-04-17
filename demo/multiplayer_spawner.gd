extends MultiplayerSpawner
@export var bird_player:PackedScene
@export var pipe_player:PackedScene
@onready var bird: TextureButton = %bird
@onready var pip: TextureButton = %pip
@onready var select_roll: Label = %selectRoll

@onready var select_your_role: CanvasLayer = %select_yourRole
signal fade_done
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
	bird.disabled=true
	pip.disabled=true
	if multiplayer.is_server():
		fade_and_continue.rpc(1) # fade pipe button
 # fade bird button
	await fade_done
	spawn_player(1)
	for id in multiplayer.get_peers():
		spawn_pipe(id)

func _on_pip_pressed() -> void:
	bird.disabled=true
	pip.disabled=true
	if multiplayer.is_server():
		fade_and_continue.rpc(-1)

	await fade_done

	spawn_pipe(1)
	for id in multiplayer.get_peers():
		spawn_player(id)

@rpc("any_peer", "call_local")
func fade_and_continue(which: int) -> void:
	var object: CanvasItem = null
	if !multiplayer.is_server():
		which*=-1
	if which == -1:
		object = bird
		select_roll.text="you are the Pipe"
	elif which == 1:
		object = pip
		select_roll.text="you are the Bird"
	


	if object == null:
		return

	var tween = create_tween()
	tween.tween_property(object, "modulate:a", 0.0, 2.0)
	await tween.finished
	object.queue_free()
	fade_done.emit()
