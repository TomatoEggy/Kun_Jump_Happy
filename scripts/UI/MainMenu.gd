extends Control

const DESKTOP_TIP: String = "按下空格键跳跃，按下S键或↓键下蹲"
const MOBILE_TIP: String = "点鸡屏幕左半边跳跃，按住屏幕右半边下蹲"

@onready var version: Label = $VBoxContainer/Version
@onready var input_tip: Label = $VBoxContainer/InputTip

func _ready() -> void:
	version.text += Game.version
	if OS.has_feature("mobile"):
		input_tip.text = MOBILE_TIP
	else:
		input_tip.text = DESKTOP_TIP


func _on_start_button_up() -> void:
	Game.change_scene(Game.difficulty_scene)


func _on_settings_button_up() -> void:
	Game.change_scene(Game.settings_menu_scene)
