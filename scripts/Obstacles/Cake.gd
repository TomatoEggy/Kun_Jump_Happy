## 油饼，可以给玩家回血

class_name Cake
extends Obstacle

const Y_POS: float = 145.0
const MOVE_VELOCITY: float = -300.0

func _ready() -> void:
	super._ready()
	not_hurt = true
	position.y = Y_POS
