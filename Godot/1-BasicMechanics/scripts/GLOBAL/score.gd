extends Sprite


# =-=-=-=-= GLOBALS =-=-=-=-=-
onready var GLOBAL_MAIN_CHARACTER = get_node("/root/MainCharacter")

# =-=-=-=-= LOCALS =-=-=-=-=-
onready var score = self

var actions_requests = {
	'reset': false
}

onready var numbers_map = {
	'01': load('res://sprites/numbers/01.png'),
	'02': load('res://sprites/numbers/02.png'),
	'03': load('res://sprites/numbers/03.png'),
	'04': load('res://sprites/numbers/04.png'),
	'05': load('res://sprites/numbers/05.png'),
	'06': load('res://sprites/numbers/06.png'),
	'07': load('res://sprites/numbers/07.png'),
	'08': load('res://sprites/numbers/08.png'),
	'09': load('res://sprites/numbers/09.png'),
	'10': load('res://sprites/numbers/10.png'),
	'11': load('res://sprites/numbers/11.png'),
	'12': load('res://sprites/numbers/12.png'),
	'13': load('res://sprites/numbers/13.png'),
	'14': load('res://sprites/numbers/14.png'),
	'15': load('res://sprites/numbers/15.png')
}


func _process(_delta):
	var current_score = str(GLOBAL_MAIN_CHARACTER.state.collected_apple)

	if current_score == '0': 
		return

	if current_score != '0':
		current_score = add_zero_to_keep_two_digits(current_score)
		score.set_texture(numbers_map[current_score])

	if actions_requests.reset:
		actions_requests.reset = false
		GLOBAL_MAIN_CHARACTER.state.collected_apple = 0


func add_zero_to_keep_two_digits(number_stringfyied):
	return '0' + number_stringfyied if len(number_stringfyied) < 2 else number_stringfyied
