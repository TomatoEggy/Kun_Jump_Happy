## 带有按下次数计数的按钮

class_name CountButton
extends TextureButton

signal count_changed(count: int)

var press_count: int

func _ready() -> void:
	button_up.connect(_on_button_up)
	
func _on_button_up():
	press_count += 1
	count_changed.emit(press_count)
