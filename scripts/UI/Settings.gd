extends Control

@export var video_scene: PackedScene

@onready var music_button: SettingsButton = $VBoxContainer/HButtonsContainer/MusicButton/Button
@onready var sounds_button: SettingsButton = $VBoxContainer/HButtonsContainer/SoundsButton/Button

func _ready() -> void:
	music_button.value = Game.bgm

func _on_exit_button_up() -> void:
	Game.save_data()
	Game.change_scene(Game.main_menu_scene)


func _on_music_button_changed(value: AudioStream) -> void:
	Game.bgm = value

