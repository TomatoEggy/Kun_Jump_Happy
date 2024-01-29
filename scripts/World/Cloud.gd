class_name Cloud
extends Sprite2D

@export var cloud_face_image: Texture2D;

@export var max_speed:float = 100;
@export var min_speed:float = 50;

@export var min_y:float = 30;
@export var max_y:float = 130;

var width: float= ProjectSettings.get_setting("display/window/size/viewport_width")

func _ready() -> void:
	if Game.chance(0.25):
		texture = cloud_face_image
	position.x = width + texture.get_width() / 2.0
	position.y = randf_range(min_y, max_y)

func _process(delta: float) -> void:
	var speed:float = randf_range(min_speed, max_speed)
	position.x -= speed * delta
	if (position.x) < -100:
		queue_free()
