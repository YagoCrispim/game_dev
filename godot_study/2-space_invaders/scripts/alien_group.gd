extends Node2D

# ----------------------------------------
#				signals
# ----------------------------------------
signal enemy_down
signal aliens_rendered
signal earth_dominated
signal victory
signal destroy_shields

# ----------------------------------------
#				consts
# ----------------------------------------
const MOV_VELOCITY: Vector2 = Vector2(6, 0)
const SHIELDS_POSITION = 232
const PLAYER_POSITION = 270
onready var TIMER_MOTHER_SHIP = $timer_mother_ship
onready var TIMER_SHOT = $timer_shot
onready var TIMER_MOVEMENT = $timer_movement
onready var TIMER_RENDER_ALIEN_INTERVAL = $timer_render_alien_interval

# ----------------------------------------
#			preload items
# ----------------------------------------
var pre_alien_shot: PackedScene = preload("res://prefabs/objects/enemy_shot/enemy_shot.tscn")
var pre_alien_explosion_anim: PackedScene = preload("res://prefabs/objects/enemy_explosion/enemy_explosion.tscn")
var pre_mother_ship: PackedScene = preload("res://prefabs/characters/mother_ship/mother_ship.tscn")

# ----------------------------------------
#				state
# ----------------------------------------
var movement_dir: int = 1
var is_player_alive: bool = true
var movement_sound = 1

# ----------------------------------------
#			objprocessing
# ----------------------------------------
func _ready() -> void:
	start_mother_ship_timer()

	for alien in $aliens.get_children():
		signal_connector(alien, "destroyed", "on_alien_destroyed")
		set_visiblity(alien, false)

	for alien in $aliens.get_children():
		TIMER_RENDER_ALIEN_INTERVAL.start()
		yield(TIMER_RENDER_ALIEN_INTERVAL, "timeout")
		set_visiblity(alien, true)

	emit_signal("aliens_rendered")
	set_timers(true)

func signal_connector(el, signal_name, method, script = self):
	el.connect(signal_name, script, method)

func set_visiblity(el: Node2D, visibility: bool) -> void:
	el.visible = visibility

func shoot() -> void:
	$enemy_sounds/events/shoot.play()
	var all_aliens = $aliens
	var n_aliens: int = all_aliens.get_child_count()

	if n_aliens > 0:
		# TODO: Error here
		print(n_aliens)
		var alien: Node2D = all_aliens.get_child(randi() % (n_aliens - 1))
		var alien_shot: Node2D = pre_alien_shot.instance()

		if alien_shot and alien:
			get_parent().add_child(alien_shot)
			alien_shot.global_position = alien.global_position

func move_down() -> void:
	position = Vector2(position.x, position.y + 8)

func on_alien_destroyed(alien) -> void:
	emit_signal("enemy_down", alien)
	var alien_explosion = pre_alien_explosion_anim.instance()
	get_parent().add_child(alien_explosion)
	alien_explosion.global_position = alien.global_position
	$enemy_sounds/events/destroyed.play()

	if $aliens.get_child_count() == 1:
		set_timers(false)
		emit_signal("victory")

func start_mother_ship_timer():
	TIMER_MOTHER_SHIP.wait_time = rand_range(2, 8)
	TIMER_MOTHER_SHIP.start()

func set_timers(state: bool) -> void:
	if state:
		TIMER_MOTHER_SHIP.start()
		TIMER_SHOT.start()
		TIMER_MOVEMENT.start()
		TIMER_RENDER_ALIEN_INTERVAL.start()
	else:
		TIMER_MOTHER_SHIP.stop()
		TIMER_SHOT.stop()
		TIMER_MOVEMENT.stop()
		TIMER_RENDER_ALIEN_INTERVAL.stop()

func is_touching_shields(alien) -> bool:
	return alien.global_position.y > SHIELDS_POSITION

func is_touching_player(alien) -> bool:
	return alien.global_position.y > PLAYER_POSITION

func play_audio() -> void:
	var node_name = "enemy_sounds/movements/" + str(movement_sound)

	get_node(node_name).play()
	if movement_sound == 4:
		movement_sound = 1
	else:
		movement_sound += 1

# ----------------------------------------
#				signals input
# ----------------------------------------
func _on_timer_shot_timeout() -> void:
	TIMER_SHOT.wait_time = rand_range(0.5, 1.5)
	shoot()

func _on_timer_movement_timeout() -> void:
	var touched = false

	play_audio()

	for alien in $aliens.get_children():
		alien.flip_sprite()
		if alien.global_position.x > 170 and movement_dir > 0:
			movement_dir = -1
			touched = true
		if alien.global_position.x < 12 and movement_dir < 0:
			movement_dir = 1
			touched = true

		if is_player_alive:
			if is_touching_shields(alien):
				emit_signal("destroy_shields")

			if is_touching_player(alien):
				is_player_alive = false
				emit_signal("earth_dominated")

	if touched:
		move_down()
		if TIMER_MOVEMENT.wait_time > 0.8:
			TIMER_MOVEMENT.wait_time = TIMER_MOVEMENT.wait_time - .1
	else:
		translate(MOV_VELOCITY * movement_dir)

func _on_mother_ship_timeout():
	var mother_ship = pre_mother_ship.instance()
	mother_ship.connect("destroyed", self, "on_alien_destroyed")
	start_mother_ship_timer()
	get_parent().add_child(mother_ship)
