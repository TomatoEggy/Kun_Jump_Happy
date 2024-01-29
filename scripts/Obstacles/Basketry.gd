extends Obstacle

const MOVE_VELOCITY: float = -300.0
const POS_Y = 286

@export var two_basketry_texture: Texture2D

func _ready() -> void:
	super._ready()
	position.y = POS_Y

	if Game.chance(Game.variables["invincible_chance"]):
		sprite.texture = two_basketry_texture
