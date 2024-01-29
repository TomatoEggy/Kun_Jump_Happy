class_name Basketball
extends Obstacle

const TOP_POS_Y: float = 145.0
const MIDDLE_POS_Y: float = 200.0
const BOTTOM_POS_Y: float = 220.0
const MOVE_VELOCITY: float = -300.0

func _ready() -> void:
	super._ready()
	if Game.chance(Game.variables["invincible_chance"]):
		position.y = TOP_POS_Y
		not_hurt = true
	else:
		var index := randi_range(0,1)
		position.y = [MIDDLE_POS_Y,BOTTOM_POS_Y][index]
