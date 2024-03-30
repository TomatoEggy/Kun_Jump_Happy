extends Node2D

@export var birthday_cake_scene: PackedScene

@onready var kun_kun: KunKun = $"KunKun"

func _ready() -> void:
	Game.score_changed.connect(create_birthday_cake)
	
func create_birthday_cake(score: int):
	if score == Game.BIRTHDAY_CAKE_SCORE :
		var cake := birthday_cake_scene.instantiate()
		add_child(cake)
		kun_kun.connect_obstacle_signal(cake)
