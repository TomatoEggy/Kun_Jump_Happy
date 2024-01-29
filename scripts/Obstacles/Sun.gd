extends Obstacle

const POS_Y := 150.0

func _ready() -> void:
	super._ready()
	position.y = POS_Y
	velocity.x = Game.variables["sun_force"].x

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += Game.gravity * delta
	if is_on_floor():
		velocity = Game.variables["sun_force"]
	move_and_slide()
