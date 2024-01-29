## 障碍物类
class_name Obstacle 
extends CharacterBody2D

## 碰撞到障碍物发出的信号
signal collided(source: Obstacle)

## 障碍物移除屏幕外销毁时发出的信号
signal destoryed(source: Obstacle)

## 该障碍物是否为非伤害型
var not_hurt: bool = false

var move_velocity = Game.variables["velocity"]

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	position.x = Game.screen_width + sprite.texture.get_width() / 2.0

func _physics_process(delta: float) -> void:
	position.x -= move_velocity * delta
	move_and_slide()

func _process(_delta: float) -> void:
	if position.x < -100:
		destoryed.emit(self)
		queue_free()

func _on_collide_area_body_entered(_body: Node2D) -> void:
	collided.emit(self)
	queue_free()
