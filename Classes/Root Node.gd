extends Spatial

export (PackedScene) var Player

var player
var spawnPoint

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $Player
	spawnPoint = $PlayerStart
	$StartCamera.make_current()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func new_game():
	$HUD.update_health(player.health)
	player.start(spawnPoint.get_translation(), spawnPoint.get_rotation())