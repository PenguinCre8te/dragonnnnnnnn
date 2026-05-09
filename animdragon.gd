extends Node3D

@onready var anim_tree = $AnimationTree
@onready var gong: AudioStreamPlayer3D = $Gong
@onready var bg: AudioStreamPlayer3D = $bg
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Set your "Mix" limit here. 
# 1.0 is full replacement, 0.5 is half-and-half.
const MIX_STRENGTH = 0.6 
var active_tween: Tween

func hi():
	# If a tween is already running, stop it so they don't fight
	if active_tween and active_tween.is_valid():
		active_tween.kill()
	active_tween = create_tween()
	bg.volume_db = -40
	gong.play()
	active_tween.tween_property(anim_tree, "parameters/Blend2/blend_amount", MIX_STRENGTH, 0.5)
	# Hold
	active_tween.tween_interval(5.8)
	active_tween.tween_property(anim_tree, "parameters/Blend2/blend_amount", 0.0, 0.5)
	bg.volume_db = -10

func start():
	bg.play()
	
func stop():
	bg.stop()
