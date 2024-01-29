## 生成油饼的节点

class_name CakeCreator
extends Creator

@onready var kun_kun: KunKun = $"../KunKun"

func _ready() -> void:
	timer.wait_time = Game.variables["create_obstacle_wait_time"]
	super._ready()

func create() -> Node:
	if Game.chance(Game.variables["cake_chance"]):
		var cake := super.create()
		kun_kun.connect_obstacle_signal(cake)
		return cake
	return null
