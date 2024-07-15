extends Label


# =-=-=-=-= GLOBALS =-=-=-=-=-
onready var GLOBAL_MAIN_CHARACTER = get_node("/root/MainCharacter")


func _process(_delta):
	var score = str(GLOBAL_MAIN_CHARACTER.state.collected_apple)
	self.set_text(score)
