extends KinematicBody2D

# ----- GLOBALS ------
onready var GLOBAL_MAIN_CHARACTER = get_node("/root/MainCharacter")

# ----- Utils ------
var timer = Timer.new()

# ----- LOCALS ------
onready var player = $AnimatedSprite
var speed = 300
var jump_speed = 450
var gravity = 1000
var velocity = Vector2.ZERO
var state = {
	'spawned': false,
	'jumping': false,
	'falling': false,
	'running': false,
}

func _ready():
	# spawn animation
	yield(get_tree().create_timer(0.5), "timeout")
	player.animation = 'spawn'
	yield(get_tree().create_timer(0.6), "timeout")
	player.animation = 'idle'
	state.spawned = true


# ----- run on every frame -----
func _physics_process(delta):
	player.play()
	player_actions(delta)
	change_sprite_as_state()
	check_if_player_is_on_the_ground()
	check_actions_requested()


func player_actions(delta):
	velocity.x = 0

	# ----- movements -----
	if Input.is_action_pressed("right"): 
		velocity.x += speed
		set_state('running', true)
		look_to_the('right')
	elif Input.is_action_pressed("left"): 
		velocity.x -= speed
		set_state('running', true)
		look_to_the('left')
	else:
		set_state('running', false)

	# ----- jumping -----
	if Input.is_action_just_pressed("jump") and is_on_floor():
		set_state('jumping', true)
		velocity.y -= jump_speed

	# ----- falling -----
	if is_falling() and not is_on_floor(): set_state('falling', true)
	if is_falling() and is_on_floor(): set_state('falling', false)

	# ----- estudar mais -----
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.y += gravity * delta

func check_if_player_is_on_the_ground():
	# is_zero_approx(velocity.y) == Velocidade no eixo y (caindo)
	var new_state = false if is_on_floor() and not is_zero_approx(velocity.y) else true
	return set_state('jumping', new_state)

func change_sprite_as_state():
	if not state.spawned: return

	if state.running: player.animation = 'running'
	else: player.animation = 'idle'

	if state.jumping: player.animation = 'jumping'
	if state.falling: player.animation = 'falling'

func check_actions_requested():
	if GLOBAL_MAIN_CHARACTER.actions_requests.respawn:
		GLOBAL_MAIN_CHARACTER.actions_requests.respawn = false
		get_tree().reload_current_scene()

# ----- helpers func -----
func set_state(key, value):
	state[key] = value

func is_falling():
	return true if velocity.y > 0 else false

func look_to_the(side):
	if side == 'left': player.flip_h = true
	else: player.flip_h = false


func _on_flag_body_entered(_body):
	GLOBAL_MAIN_CHARACTER.state.collected_apple = 0
