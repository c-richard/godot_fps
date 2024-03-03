extends Node3D

var peer = ENetMultiplayerPeer.new();

@export var player_scene: PackedScene

func _ready():
	print("Starting game as ", Role.role)
	if (Role.role == "Host"):
		peer.create_server(1080)
		multiplayer.multiplayer_peer = peer
		multiplayer.peer_connected.connect(_add_player)
		_add_player()
	if (Role.role == "Client"):
		peer.create_client("localhost", 1080)
		multiplayer.multiplayer_peer = peer

func _add_player(id = 1):
	print("Add player: ", id)
	var player = player_scene.instantiate()
	player.name = str(id)
	get_node("Network").add_child(player)


