extends Node

@onready var dragonanim: AnimationPlayer = $models/dragon/AnimationPlayer
@onready var models: Node = $models
@onready var sleighanim: AnimationPlayer = $models/sleigh/AnimationPlayer
@onready var dragon: Node3D = $models/dragon
@onready var label: Label = $Camera3D/Control/Label

var socket = WebSocketPeer.new()
var url = "ws://192.168.4.1:81"

func show_only_model(target_name: String):
	if target_name == "sleigh":
		sleighanim.get_animation("Armature_002|running_Object_9").loop_mode = Animation.LOOP_LINEAR
		sleighanim.play("Armature_002|running_Object_9")
	if target_name == "dragon":
		dragonanim.get_animation("flying").loop_mode = Animation.LOOP_LINEAR
		dragonanim.play("flying")
		
	for child in models.get_children():
		child.visible = (child.name == target_name)
		
func _ready():
	show_only_model("dragon")
	socket.connect_to_url(url)

func _process(_delta):
	socket.poll()
	var state = socket.get_ready_state()
	
	# Update the UI Label with the current status
	_update_ws_label(state)
	
	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count() > 0:
			var packet = socket.get_packet()
			var data_string = packet.get_string_from_utf8()
			_handle_message(data_string)
	if state == WebSocketPeer.STATE_CLOSED:
		var code = socket.get_close_code()
		var reason = socket.get_close_reason()
		if code != -1:
			label.text = "Error: " + str(code) + " " + reason
			return # Don't overwrite with the generic message below

func _update_ws_label(state):
	match state:
		WebSocketPeer.STATE_CONNECTING:
			label.text = "Connecting..."
			label.modulate = Color.RED
		WebSocketPeer.STATE_OPEN:
			label.text = "Connected"
			label.modulate = Color.GREEN
		WebSocketPeer.STATE_CLOSING:
			label.text = "Closing..."
			label.modulate = Color.ORANGE
		WebSocketPeer.STATE_CLOSED:
			label.text = "Disconnected"
			label.modulate = Color.RED

func _handle_message(json_string: String):
	var json = JSON.new()
	var error = json.parse(json_string)
	
	if error == OK:
		var data = json.data
		if data.has("trigger") and data["trigger"] == true:
			dragon.hi()
		if data.has("change"):
			show_only_model(data["change"])

func _on_label_gui_input(event: InputEvent) -> void:
	# Check if the event is a mouse button click
	if event is InputEventMouseButton:
		# Check if it was the left mouse button AND it was just pressed (not released)
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			dragon.hi()
