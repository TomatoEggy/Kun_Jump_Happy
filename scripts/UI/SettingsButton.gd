class_name SettingsButton
extends CountButton

signal changed(value)

@export var options: Dictionary
@export var default_key: String

@onready var button_text: Label = $"Text"

## 当前的选项索引
var index: int:
	set(v):
		if v >= len(options):
			index = 0
		else:
			index = v
		button_text.text = options.keys()[index]
		
## 对应的值
var value:
	get:
		var key: String = options.keys()[index]
		return options[key]
	set(v):
		value = v
		var key = options.find_key(v)
		index = Game.get_key_index(options, key)

func _ready() -> void:
	super()
	index = Game.get_key_index(options, default_key)
	button_up.connect(func(): 
		index += 1
		changed.emit(value)
	)
	count_changed.connect(click10times)
	
func click10times(count: int) -> void:
	if count >= 10:
		AudioServer.set_bus_mute(1, true)
		Game.change_scene(owner.video_scene)
