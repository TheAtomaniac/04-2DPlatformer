extends Node

onready var SM = get_parent()
onready var player = get_node("../..")

func _ready():
	yield(player, "ready")

func start():
	player.collision_layer = 0
	player.collision_mask = 0
	player.set_animation("Dead")
	player.velocity = Vector2.ZERO
