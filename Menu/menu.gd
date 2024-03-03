extends Control

var peer = ENetMultiplayerPeer.new();

@export var player_scene: PackedScene

func _on_host_pressed():
	get_tree().change_scene_to_file("res://Game/Game.tscn")
	Role.role = "Host"

func _on_join_pressed():
	get_tree().change_scene_to_file("res://Game/Game.tscn")
	Role.role = "Client"
