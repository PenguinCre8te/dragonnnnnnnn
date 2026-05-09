extends Node3D
@onready var music: AudioStreamPlayer3D = $music
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func stop():
	music.stop()

func start():
	animation_player.get_animation("Armature_002|running_Object_9").loop_mode = Animation.LOOP_LINEAR
	animation_player.play("Armature_002|running_Object_9")
