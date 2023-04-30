extends Control

func _physics_process(_delta):
	update_health()
	update_score()

func update_health():
	$Healthbar.value = Global.health
	if $Healthbar.value > 7:
		$Healthbar.tint_progress = Color.green
	elif $Healthbar.value <= 7 and $Healthbar.value > 3:
		$Healthbar.tint_progress = Color.yellow
	elif $Healthbar.value <= 3:
		$Healthbar.tint_progress = Color.red

func update_score():
	$Score.text = "Score: " + str(Global.score)
