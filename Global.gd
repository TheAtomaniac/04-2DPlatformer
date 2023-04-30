extends Node

var health = 10
var score = 0

var fade = null
var fade_speed = 0.015

var fade_in = false
var fade_out = ""

var death_zone = 1000

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func update_health(h):
	health = clamp(health - h, 0, 10)

func update_score(s):
	score += s

func reset():
	score = 0
	health = 10


func _physics_process(_delta):
	if fade == null:
		fade = get_node_or_null("/root/Game/Camera/Fade")
	if fade_out != "":
		execute_fade_out(fade_out)
	if fade_in:
		execute_fade_in()
		

func start_fade_in():
	if fade != null:
		fade.visible = true
		fade.color.a = 1
		fade_in = true

func start_fade_out(target):
	if fade != null:
		fade.color.a = 0
		fade.visible = true
		fade_out = target

func execute_fade_in():
	if fade != null:
		fade.color.a -= fade_speed
		if fade.color.a <= 0:
			fade_in = false

func execute_fade_out(_target):
	if fade != null:
		fade.color.a += fade_speed
		if fade.color.a >= 1:
			fade_out = ""
			
func _unhandled_input(_event):
	if Input.is_action_just_pressed("menu"):
		var Pause_Menu = get_node_or_null("/root/Game/UI/Pause_Menu")
		if Pause_Menu == null:
			get_tree().quit()
		else:
			if Pause_Menu.visible:
				Pause_Menu.hide()
				get_tree().paused = false
			else:
				Pause_Menu.show()
				get_tree().paused = true
