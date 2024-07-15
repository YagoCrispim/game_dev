extends Area2D

# ----------------------------------------
#				signals
# ----------------------------------------
signal destroied
signal respawn

# ----------------------------------------
#				consts
# ----------------------------------------
const LEFT_LIMIT: int = 9
const RIGHT_LIMIT: int = 172
const VELOCITY: int = 100
onready var LIMIT_SHOTS_ON_SCREEN: int = 100

# ----------------------------------------
#			preload items
# ----------------------------------------
var pre_shot:PackedScene = preload("res://prefabs/objects/player_shot/ship_lazer.tscn")

# ----------------------------------------
#				state
# ----------------------------------------
var is_hidden = true
var alive: bool = true
var left: bool = false
var right: bool = false
var dir: int = 0
var lazer: bool = false

# ----------------------------------------
#			obj processing
# ----------------------------------------
func _ready():
	hide()

func _process(delta):
	if stop_process(): return

	handle_controls()
	movimentation(delta)
	shot()

func start():
	show()

func disable():
	hide()
	alive = false

func handle_controls() -> void:
	left = Input.is_action_pressed("ui_left")
	right = Input.is_action_pressed("ui_right")
	lazer = Input.is_action_pressed("fire_ship_lazer") # TODO: change to "is_action_just_pressed"

func movimentation(delta) -> void:
	dir = 0

	if left and position.x > LEFT_LIMIT: dir = move("left")
	if right and position.x < RIGHT_LIMIT: dir = move("right")

	translate(Vector2(1, 0) * VELOCITY * dir * delta)

func shot() -> void:
	if not alive: return

	var shot_on_screen = get_el_inside_group("ship_shot")
	if not lazer or shot_on_screen >= LIMIT_SHOTS_ON_SCREEN:
		return

	$sounds/shoot.play()
	var shot = pre_shot.instance()
	shot.position = position
	get_parent().add_child(shot)

func move(side: String) -> int:
	return -1 if side == "left" else 1

func get_el_inside_group(group_name: String) -> int:
	return get_tree().get_nodes_in_group(group_name).size()

func stop_process() -> bool:
	if not alive and is_hidden:
		return true
	return false

func respawn():
	emit_signal("respawn")
	$sprite.frame = 0
	alive = true

func destroy():
	if alive:
#		$sounds/explosion.play()
		alive = false
		emit_signal("destroied")
		$sprite/anim.play("explode")
		yield($sprite/anim, "animation_finished")
		respawn()
