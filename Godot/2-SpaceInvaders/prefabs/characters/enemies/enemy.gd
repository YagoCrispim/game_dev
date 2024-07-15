tool
extends Area2D

# ----------------------------------------
#				consts
# ----------------------------------------
onready var SPRITE: Sprite = $sprite
export(int, "A", "B", "C") var selected_enemy_idx: int = 0 setget set_selected_enemy
const ENEMIES = [
	{
		"score": 30,
		"texture": preload("res://assets/sprites/InvaderA_sheet.png")
	},
	{
		"score": 20,
		"texture": preload("res://assets/sprites/InvaderB_sheet.png")
	},
	{
		"score": 10,
		"texture": preload("res://assets/sprites/InvaderC_sheet.png")
	}
]

# ----------------------------------------
#			signals declarations
# ----------------------------------------
signal destroyed(obj) # sinal personalizado

# ----------------------------------------
#				state
# ----------------------------------------
var score: int = 0
var sprite: int = 0

# ----------------------------------------
#				processing
# ----------------------------------------
func _draw():
	SPRITE.texture = ENEMIES[selected_enemy_idx].texture
	score = ENEMIES[selected_enemy_idx].score

func is_editing_mode() -> bool:
	return is_inside_tree() and Engine.is_editor_hint()

func set_selected_enemy(val):
	selected_enemy_idx = val
	if is_editing_mode(): update()

func destroy():
	emit_signal("destroyed", self)
	queue_free()

func flip_sprite():
	var next_frame = 1 if SPRITE.frame == 0 else 0
	SPRITE.frame = next_frame

# ----------------------------------------
#			signals impl
# ----------------------------------------
func _on_enemy_area_entered(area):
	if area.has_method("destroy"):
		area.destroy()
