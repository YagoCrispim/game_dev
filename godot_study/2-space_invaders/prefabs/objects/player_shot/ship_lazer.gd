extends Area2D

# ----------------------------------------
#				state
# ----------------------------------------
export var vel = 200
var dir = Vector2(0, -1)

# ----------------------------------------
#			obj processing
# ----------------------------------------
func _ready():
	add_to_group("ship_shot")

func _process(delta):
	if position.y < 0: destroy()
	translate(dir * vel * delta )

func destroy():
	queue_free()

func _on_ship_shot_area_entered(area):
	if area.has_method("destroy"):
		queue_free()
		area.destroy()
