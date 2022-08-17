extends HBoxContainer


var pos: String = "1ST" setget set_pos
var player_name: String = "" setget set_name
var score: String = "0" setget set_score
var color: Color = Color(1,1,1,1) setget set_color

func set_pos(val):
	pos = val
	$pos.text = str(val)

func set_name(val):
	player_name = val
	$name.text = val

func set_score(val):
	score = str(val)
	$score.text = score

func set_color(val):
	color = val
	$name.add_color_override("font_color", color)
	$pos.add_color_override("font_color", color)
	$score.add_color_override("font_color", color)
