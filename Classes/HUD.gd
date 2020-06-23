extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	$HealthAmount.hide()
	$HealthDisplay.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_pressed():
	$StartButton.hide()
	$HealthAmount.show()
	$HealthDisplay.show()
	emit_signal("start_game")

func update_health(newHealth):
	$HealthAmount.text = str(newHealth)