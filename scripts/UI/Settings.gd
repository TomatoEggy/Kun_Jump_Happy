extends Control

@onready var music_button: ToggleButton = $VBoxContainer/HButtonsContainer/MusicButton/Button
@onready var sounds_button: ToggleButton = $VBoxContainer/HButtonsContainer/SoundsButton/Button

func _ready() -> void:
	music_button.value = Game.bgm
	sounds_button.value = not Game.mute_sounds

func _on_exit_button_up() -> void:
	Game.save_data()
	Game.change_scene(Game.main_menu_scene)


func _on_music_button_changed(value: AudioStream) -> void:
	Game.bgm = value


func _on_sounds_button_changed(value: bool) -> void:
	Game.mute_sounds = not value
