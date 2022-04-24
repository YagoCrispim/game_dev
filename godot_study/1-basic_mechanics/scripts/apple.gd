extends Node2D


# =-=-=-=-= GLOBALS =-=-=-=-=-
onready var GLOBAL_MAIN_CHARACTER = get_node("/root/MainCharacter")


# =-=-=-=-= LOCALS =-=-=-=-=-
var state = {
	'idle': true,
	'collected': false
}


func _on_apple_body_entered(_body):
	GLOBAL_MAIN_CHARACTER.state.collected_apple += 1
	queue_free()
