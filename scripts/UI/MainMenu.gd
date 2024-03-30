extends Control

var can_press_button: bool = false

@onready var input_tip: Label = $InputTip/InputTip

func _ready() -> void:
	if OS.has_feature("mobile"):
		input_tip.text = "点鸡屏幕左半边跳跃，按住屏幕右半边下蹲"
	else:
		input_tip.text = "按下空格键跳跃，按下S键或↓键下蹲"

func change_tip() -> void:
	if OS.has_feature("mobile"):
		input_tip.text = "点鸡屏幕右半边跳跃，按住屏幕左半边下蹲"
	else:
		input_tip.text = "按下S键或↓键跳跃，按下空格键下蹲"

func _on_start_button_up() -> void:
	if can_press_button:
		Game.change_scene(Game.difficulty_scene)


func _on_settings_button_up() -> void:
	if can_press_button:
		Game.change_scene(Game.settings_menu_scene)

