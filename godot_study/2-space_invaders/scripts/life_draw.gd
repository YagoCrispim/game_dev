tool
extends Node2D

# ----------------------------------------
#				state
# ----------------------------------------
export(Texture) var texture
export(int) var lifes: int = 3 setget set_lifes

# ----------------------------------------
#			obj processing
# ----------------------------------------
func _draw():
	for life in range(lifes):
		draw_texture_rect_region(texture, Rect2(life * 18,5,15,8), Rect2(0,0,15,8), Color(1,1,1,1), false)

func set_lifes(val: int): # REFACTOR. Buscas esses dados do contexto global
	lifes = val
	update()
