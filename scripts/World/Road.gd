extends Node2D

var velocity = Game.variables["velocity"]

@onready var road_1: Sprite2D = $Graphics/Road1
@onready var road_2: Sprite2D = $Graphics/Road2

var width = ProjectSettings.get_setting("display/window/size/viewport_width")

func _process(delta: float) -> void:
	road_1.position.x -= velocity * delta
	road_2.position.x -= velocity * delta
	if road_1.position.x < -width:
		road_1.position.x = road_2.position.x + width
	if road_2.position.x < -width:
		road_2.position.x = road_1.position.x + width
