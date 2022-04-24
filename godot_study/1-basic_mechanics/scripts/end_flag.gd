extends Area2D

# ----- GLOBALS ------
onready var GLOBAL_MAIN_CHARACTER = get_node("/root/MainCharacter")

# ----- LOCALS ------
onready var flag_sprite = $AnimatedSprite
onready var flag_body = $CollisionShape2D

func _ready():
	flag_body.disabled = true


func _physics_process(_delta):
	if GLOBAL_MAIN_CHARACTER.state.collected_apple >= 15:
		flag_body.disabled = false
		flag_sprite.animation = 'showing_flag'


func _on_flag_body_entered(body):
	if body.name == 'main_player':
		GLOBAL_MAIN_CHARACTER.actions_requests.respawn = true
		flag_sprite.animation = 'idle'
