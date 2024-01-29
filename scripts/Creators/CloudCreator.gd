class_name CloudCreator
extends Creator

@export var max_create_cloud_time = 7;
@export var min_create_cloud_time = 5.5;

func _ready() -> void:
	reset_timer_wait_time()
	super._ready()

func reset_timer_wait_time() -> void:
	timer.wait_time = randf_range(min_create_cloud_time, max_create_cloud_time)

func _on_timer_timeout() -> void:
	super._on_timer_timeout()
	reset_timer_wait_time()
