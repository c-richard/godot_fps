extends Control

var peer = ENetMultiplayerPeer.new();

@export var player_scene: PackedScene

func _on_host_pressed():
	get_tree().change_scene_to_file("res://world.tscn")
	Role.role = "Host"
	#peer.create_server(1080)
	#multiplayer.multiplayer_peer = peer
	#multiplayer.peer_connected.connect(_add_player)
	
func _on_join_pressed():
	get_tree().change_scene_to_file("res://world.tscn")
	Role.role = "Client"
	#peer.create_client("localhost", 1080)
	#multiplayer.multiplayer_peer = peer
	#get_tree().change_scene_to_file("res://world.tscn")

func _add_player(id = 1):
	#print("Add player")
	#var player = player_scene.instantiate()
	#player.name = str(id)
	#call_deferred("add_child", player)
	pass

