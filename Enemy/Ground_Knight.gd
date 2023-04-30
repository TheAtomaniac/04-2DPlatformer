extends KinematicBody2D

onready var SM = $StateMachine
onready var effect = $Effect

export var walking = 100
export var path = [Vector2(0,0), Vector2(0,0)]
var velocity = Vector2.ZERO
var direction = 1
var health = 2


func _ready():
	effect.play("Normal")
	position = path[0]
	velocity.x = walking
	SM.set_state("Move")

func _physics_process(_delta):
	velocity = move_and_slide(velocity, Vector2.ZERO)
	
	if velocity.x < 0 and not $AnimatedSprite.flip_h: 
		$AnimatedSprite.flip_h = true
		direction = -1
		$Attack.cast_to.x = -1*abs($Attack.cast_to.x)
	if velocity.x > 0 and $AnimatedSprite.flip_h: 
		$AnimatedSprite.flip_h = false
		direction = 1
		$Attack.cast_to.x = abs($Attack.cast_to.x)
	
func set_animation(anim):
	if $AnimatedSprite.animation == anim: return
	if $AnimatedSprite.frames.has_animation(anim): $AnimatedSprite.play(anim)
	else: $AnimatedSprite.play()

func hit(d):
	health -= d
	effect.play("Hurt")
	if health <= 0:
		Global.update_score(150)
		SM.set_state("Die")

func should_attack():
	if $Attack.is_colliding() and $Attack.get_collider().name == "Player":
		return true
	return false

func attack_target():
	if $Attack.is_colliding():
		return $Attack.get_collider()
	return null

func _on_AnimatedSprite_animation_finished():
	if SM.state_name == "Attack":
		SM.set_state("Move")
	if SM.state_name == "Die":
		queue_free()
