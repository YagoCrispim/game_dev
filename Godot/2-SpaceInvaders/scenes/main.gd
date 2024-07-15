extends Node2D

# ----------------------------------------
#				consts
# ----------------------------------------
const HISCORE_FILE = "user://hiscore_file"

# ----------------------------------------
#			preload items
# ----------------------------------------
var pre_game: PackedScene = preload("res://scenes/game/game.tscn")
var pre_name_selector: PackedScene = preload("res://scenes/name_selector/name_selector.tscn")

# ----------------------------------------
#				state
# ----------------------------------------
var game: Node
var state
var hiscore
var hiscores = [
	{name = "AAA", score = 1000},
	{name = "BBB", score = 900},
	{name = "CCC", score = 800},
	{name = "DDD", score = 700},
	{name = "EEE", score = 600},
	{name = "FFF", score = 500},
	{name = "GGG", score = 400},
	{name = "HHH", score = 300},
	{name = "III", score = 200},
	{name = "JJJ", score = 100}
]

# ----------------------------------------
#			objprocessing
# ----------------------------------------
func _ready():
	load_hiscores()
	mount_hiscore()

func _process(_delta):
	pass

func new_game():
	if game != null:
		game.queue_free()

	game = pre_game.instance()
	call_deferred("add_child_to_local_tree", game)
	# warning-ignore:return_value_discarded
	game.connect("game_over", self, "on_game_over")
	# warning-ignore:return_value_discarded
	game.connect("victory", self, "on_victory")

func add_child_to_local_tree(obj):
	$game_node.add_child(obj)

func on_game_over():
	hiscore = null

	for hs in hiscores:
		if game.state.score > hs.score:
			hiscore = hs
			break

	if hiscore:
		var name_selector = pre_name_selector.instance()
		add_child(name_selector)
		name_selector.connect("finished", self, "on_name_selector_finished")
		yield(name_selector, "finished")
		name_selector.queue_free()
		save_hiscores()

	$btn_new_game.show()
	$hiscore.show()
	$game_node.hide()
	$logo.show()
	$hiscore.mount_hiscores_table(hiscores)

func save_hiscores():
	var file: File = File.new()
	var result = file.open(HISCORE_FILE, file.WRITE)

	if result == OK:
		file.store_line(to_json(hiscores))
		file.close()

func load_hiscores():
	var file = File.new()
	var result = file.open(HISCORE_FILE, file.READ)

	if result == OK:
		var persisted_hiscore = parse_json(file.get_as_text())
		hiscores = persisted_hiscore
		file.close()

func on_name_selector_finished(val: String):
	var idx = hiscores.find(hiscore)
	hiscores.insert(idx, { name = val, score = game.state.score })
	hiscores.resize(10)

func on_victory():
	state = game.state
	new_game()
	game.state = state

func mount_hiscore():
	$hiscore.mount_hiscores_table(hiscores)

# ----------------------------------------
#				signals input
# ----------------------------------------
func _on_play_button_pressed():
	$btn_new_game.hide()
	$hiscore.hide()
	$logo.hide()
	new_game()
