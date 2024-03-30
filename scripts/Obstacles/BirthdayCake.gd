## 1周年蛋糕，可以让玩家回血并使得分以2~3倍增长

class_name BirthdayCake
extends Obstacle

const Y_POS: float = 195.0

func _ready() -> void:
	super()
	not_hurt = true
	position.y = Y_POS
