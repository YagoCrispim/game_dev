extends Area2D

# ----------------------------------------
#				state
# ----------------------------------------
var hits = 0

# ----------------------------------------
#			obj processing
# ----------------------------------------
func destroy():
	hits += 1
	if hits != 6:
		$sprite.frame = hits
		return

	queue_free()
