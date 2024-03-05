extends Node

@onready var input: AudioStreamPlayer = $Input
@onready var output : AudioStreamPlayer3D = $Output
@onready var multiplayer_id = get_parent().name

var index: int
var effect: AudioEffectCapture
var playback: AudioStreamGeneratorPlayback

var inputThreshold = 0.005
var receiveBuffer := PackedFloat32Array()

# Called when the node enters the scene tree for the first time.

func _ready():
	print("I am ", multiplayer_id, "\t Authority: ", is_multiplayer_authority())
	
	if is_multiplayer_authority():
		input.stream = AudioStreamMicrophone.new()
		input.play()
		index = AudioServer.get_bus_index("Record")
		effect = AudioServer.get_bus_effect(index, 0)
		
	playback = output.get_stream_playback()

var has_said_processing_input = false

func _process(_delta):
	if has_said_processing_input == false and is_multiplayer_authority():
		has_said_processing_input = true;
		print("Processing mic for ", multiplayer_id)
	
	if is_multiplayer_authority():
		processMic()
		
	processVoice()
		
func processMic():
	var sterioData : PackedVector2Array = effect.get_buffer(effect.get_frames_available())
	
	if sterioData.size() > 0:
		var data = PackedFloat32Array()
		data.resize(sterioData.size())
		var maxAmplitude := 0.0;
		
		for i in range(sterioData.size()):
			var value = (sterioData[i].x + sterioData[i].y) / 2
			maxAmplitude = max(value, maxAmplitude)
			data[i] = value

		if maxAmplitude < inputThreshold:
			return

		sendData.rpc(data)

func processVoice():
	if receiveBuffer.size() <= 0:
		return
	
	
	for i in range(min(playback.get_frames_available(), receiveBuffer.size())):
		playback.push_frame(Vector2(receiveBuffer[0], receiveBuffer[0]))
		receiveBuffer.remove_at(0)

var has_said_received = false

@rpc("any_peer", "call_remote", "unreliable_ordered")
func sendData(data: PackedFloat32Array):
	if has_said_received == false:
		has_said_received = true
		print(multiplayer_id, " is processing data from: ", multiplayer.get_remote_sender_id())
	receiveBuffer.append_array(data)

