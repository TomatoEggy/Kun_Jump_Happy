## 用于创建特定节点的节点

class_name Creator
extends Node2D

## 要生成的节点场景
@export var node_scene: PackedScene

## 生成节点间隔时间的计时器
@export var timer: Timer

func _ready() -> void:
	create()
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

## 生成节点
func create() -> Node:
	var node := node_scene.instantiate()
	add_child(node)
	return node

func _on_timer_timeout():
	create()
