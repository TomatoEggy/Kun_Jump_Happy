## 生成油饼的节点

class_name CakeCreator
extends Creator

@export var birthday_cake_scene: PackedScene

@onready var kun_kun: KunKun = $"../KunKun"

func create() -> Node:
	if Game.chance(Game.variables["cake_chance"]):
		var cake := super.create()
		kun_kun.connect_obstacle_signal(cake)
		return cake
	return null

func _on_timer_timeout() -> void:
	if Game.score != Game.BIRTHDAY_CAKE_SCORE:
		super()
