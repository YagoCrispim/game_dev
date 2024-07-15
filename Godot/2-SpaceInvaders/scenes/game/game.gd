extends Node2D

# ----------------------------------------
#				consts
# ----------------------------------------
onready var score_node = $HUD/score
const EXTRA_LIFE_POINTS = [100000000, 250, 500]

# ----------------------------------------
#				state
# ----------------------------------------
var state = {
	lifes = 1,
	extra_life_idx = 0,
	score = 0,
} setget set_data

# ----------------------------------------
#				signals
# ----------------------------------------
signal game_over
signal victory

# ----------------------------------------
#			obj processing
# ----------------------------------------
func _ready():
	randomize()
	exec_debug_changes() # debug

	update_score()
	# warning-ignore:return_value_discarded
	$alien_group.connect("enemy_down", self, "on_alien_group_enemy_down")
	# warning-ignore:return_value_discarded
	$alien_group.connect("earth_dominated", self, "on_alien_group_earth_dominated")
	# warning-ignore:return_value_discarded
	$alien_group.connect("aliens_rendered", self, "on_alien_group_rendered")
	# warning-ignore:return_value_discarded
	$alien_group.connect("destroy_shields", self, "on_alien_group_touch_shields")
	# warning-ignore:return_value_discarded
	$alien_group.connect("victory", self, "on_alien_group_fully_destroied")
	# warning-ignore:return_value_discarded
	$player.connect("destroied", self, "on_player_destroied")
	# warning-ignore:return_value_discarded
	$player.connect("respawn", self, "on_player_respawn")

func on_alien_group_fully_destroied():
	emit_signal("victory")
	$alien_group.set_timers(false)
	$player.disable()

func on_alien_group_rendered():
	$player.start()

func on_alien_group_enemy_down(alien):
	state.score += alien.score
	update_score()

	if state.extra_life_idx < EXTRA_LIFE_POINTS.size() and state.score >= EXTRA_LIFE_POINTS[state.extra_life_idx]:
		state.lifes += 1
		state.extra_life_idx += 1
		update_lifes()

func update_lifes():
	$HUD/life_draw.lifes = state.lifes

func on_alien_group_touch_shields():
	for shield in $shields.get_children():
		if shield.has_method("destroy"):
			shield.destroy()

func update_hud():
	update_score()
	update_lifes()

func on_alien_group_earth_dominated():
	game_over()

func update_score() -> void:
	print(score_node, '->', state)
	if score_node:
		score_node.text = str(state.score)

func on_player_respawn():
	if state.lifes <= 0:
		game_over()
	else:
		$alien_group.set_timers(true)

func game_over():
	$alien_group.set_timers(false)

	if $player:
		$player.visible = false

	if $shields:
		$shields.visible = false

	emit_signal("game_over")

func on_player_destroied():
	if state.lifes <= 0: return

	state.lifes -= 1
	$alien_group.set_timers(true)
	$HUD/life_draw.lifes = state.lifes

	get_tree().call_group("alien_shot", "destroy")

func set_data(data):
	state = data
	update_hud()

# ----------------------------------------
#				debug
# ----------------------------------------
var debug: bool = false
var remove_shields = debug

func exec_debug_changes():
	show_debug_hud()
	hide_shields()

# exported
func is_debug_mode_on() -> bool:
	return debug

func show_debug_hud():
	$debug.visible = true if is_debug_mode_on() else false

func hide_shields() -> void:
	if remove_shields:
		$".".remove_child($shields)
