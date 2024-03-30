## 用于生成障碍

class_name ObstacleCreator
extends Creator

## 不同种类的障碍生成的周期循环
var obstacle_range: int = Game.variables["obstacle_range"]

## 不同的障碍场景
@export var obstacle_scenes: Array[PackedScene]

@onready var kun_kun: KunKun = $"../KunKun"

@onready var current_obstacle_scene = obstacle_scenes[0]
@onready var current_obstacle: int = 0:
	set(v):
		if v >= len(obstacle_scenes):
			current_obstacle = 0
		else:
			current_obstacle = v
		current_obstacle_scene = obstacle_scenes[current_obstacle]
var current_obstacle_num = 1

func _ready() -> void:
	timer.wait_time = Game.variables["create_obstacle_wait_time"]
	create_obstacle(current_obstacle_scene)
	timer.start()

## 创建障碍
func create_obstacle(obstacle: PackedScene) -> void:
	var obstacle_node := obstacle.instantiate()
	add_child(obstacle_node)
	kun_kun.connect_obstacle_signal(obstacle_node)
	current_obstacle_num += 1


func _on_timer_timeout() -> void:
	if Game.score != Game.BIRTHDAY_CAKE_SCORE:
		if current_obstacle_num > obstacle_range:
			current_obstacle += 1
			current_obstacle_num = 1
		create_obstacle(current_obstacle_scene)
	timer.start()
