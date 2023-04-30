extends Node

onready var SM = get_parent()
onready var player = get_node("../..")

onready var prev_direction = player.direction

func _ready():
	yield(player, "ready")

func start():
	player.set_animation("Moving")
	player.jump_power = Vector2.ZERO

func physics_process(_delta):
	if not player.is_on_floor():
		SM.set_state("Falling")
	else:
		player.velocity.y = 0
	if Input.is_action_pressed("jump") and player.jump_reset:
		var jump = get_node_or_null("/root/Game/Sounds/Jump")
		if jump != null:
			jump.play()
		SM.set_state("Jumping")
	if player.is_moving():
		if player.direction != prev_direction:
			player.velocity.x = 0
			prev_direction = player.direction
		player.velocity += player.move_speed * player.move_vector()
		if player.reverse:
			player.move_and_slide(player.velocity, Vector2.DOWN)
		else:
			player.move_and_slide(player.velocity, Vector2.UP)
	else:
		player.velocity = Vector2.ZERO
		SM.set_state("Idle")
