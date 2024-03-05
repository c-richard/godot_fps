extends Node3D

var peer = ENetMultiplayerPeer.new();

@export var player_scene: PackedScene

func _ready():
	if (Role.role == "Host"):
		peer.create_server(1080)
		multiplayer.multiplayer_peer = peer
		multiplayer.peer_connected.connect(_add_player)
		multiplayer.peer_disconnected.connect(_remove_player)
		_add_player()
	if (Role.role == "Client"):
		#peer.create_client("localhost", 1080)
		peer.create_client("100.66.154.3", 1080)
		multiplayer.multiplayer_peer = peer

func _add_player(id = 1):
	print("Add player: ", id)
	var player = player_scene.instantiate()
	player.name = str(id)
	get_node("Players").add_child(player)
	
func _remove_player(id = 1):
	print("Remove player: ", id) 

func _process(_delta):
	peer.poll()	
	pass

