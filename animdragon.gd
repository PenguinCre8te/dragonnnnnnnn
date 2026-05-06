extends Node3D

@onready var anim_tree = $AnimationTree

# Set your "Mix" limit here. 
# 1.0 is full replacement, 0.5 is half-and-half.
const MIX_STRENGTH = 0.6 

func trigger_mixed_action():
	var tween = create_tween()
	
	# Slide from 0 (No Mix) to 0.5 (Partial Mix)
	# We use a small duration (0.1) to make it feel fluid, not a snap
	tween.tween_property(anim_tree, "parameters/Blend2/blend_amount", MIX_STRENGTH, 0.1)
	
	# Hold the mix for a moment
	tween.tween_interval(5.8)
	
	# Slide back to 0 (Pure Constant animation)
	tween.tween_property(anim_tree, "parameters/Blend2/blend_amount", 0.0, 0.2)

# Example: Triggering with the space bar
func hi():
	trigger_mixed_action()
