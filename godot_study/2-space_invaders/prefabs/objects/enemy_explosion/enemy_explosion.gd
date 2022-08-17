extends Node2D

# ----------------------------------------
#				consts
# ----------------------------------------
onready var ANIM: AnimationPlayer = $anim

# ----------------------------------------
#			obj processing
# ----------------------------------------
func _ready():
	ANIM.play("explosion")
	yield(ANIM, "animation_finished")
	destroy()

func destroy():
	queue_free()
