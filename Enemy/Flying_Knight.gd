extends KinematicBody2D

onready var effect = $AnimationPlayer


var player = null
export var speed = 40
var health = 1
var damage = 1

var mode = ""

var points = []
const margin = 1.5


func _ready():
	change_mode("move")

func _physics_process(_delta):
	var velocity = Vector2.ZERO
	player = get_node_or_null("/root/Game/Player_Container/Player")
	if player != null and mode != "dead":
		if points.size() > 1:
			var distance = points[1] - global_position
			var direction = distance.normalized()
			$AnimatedSprite.flip_h = false
			if direction.x < 0:
				$AnimatedSprite.flip_h = true
			if distance.length() > margin or points.size() > 2:
				velocity = direction * speed
	velocity = move_and_slide(velocity, Vector2.ZERO)

func change_mode(m):
	if mode != m and mode != "dead":
		mode = m
		$AnimatedSprite.play(mode)

func hit(d):
	effect.play("Hurt")
	health -= d
	if health <= 0:
		change_mode("dead")
		Global.update_score(100)

func _on_Attack_body_entered(body):
	if body.name == "Player":
		if mode != "attack":
			var sound = get_node_or_null("/root/Game/Sounds/Angry")
			if sound != null:
				sound.play()
			change_mode("attack")
			$Timer.start()

func _on_Timer_timeout():
	if mode == "attack":
		var bodies = $Attack.get_overlapping_bodies()
		for body in bodies:
			if body.name == "Player":
				queue_free()


func _on_AnimatedSprite_animation_finished():
	if mode == "dead":
		queue_free()
