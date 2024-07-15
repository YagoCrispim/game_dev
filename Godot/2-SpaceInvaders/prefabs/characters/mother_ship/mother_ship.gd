extends Area2D

# ----------------------------------------
#				signals
# ----------------------------------------
signal destroyed

# ----------------------------------------
#				consts
# ----------------------------------------
onready var DEFAULT = $default

# ----------------------------------------
#				state
# ----------------------------------------
var score = 200

# ----------------------------------------
#			obj processing
# ----------------------------------------
func _ready():
	DEFAULT.play("default")
	yield(DEFAULT, "animation_finished")
	queue_free()

func destroy():
	emit_signal("destroyed", self)
	queue_free()
