extends Area2D

# ----------------------------------------
#				consts
# ----------------------------------------
const BORDER_BOTTOM_LIMIT = 280

# ----------------------------------------
#				state
# ----------------------------------------
export var velocity: int = 200
var direction: Vector2 = Vector2(0, 1)

# ----------------------------------------
#			objprocessing
# ----------------------------------------
func _ready():
	add_to_group("alien_shot")

func _process(delta):
	if position.y > BORDER_BOTTOM_LIMIT: destroy()
	translate(direction * velocity * delta )

func destroy():
	queue_free()

func _on_enemy_lazer_area_entered(area):
	if area.has_method("destroy"):
		queue_free()
		area.destroy() # destroy é uma função dentro do enemy
