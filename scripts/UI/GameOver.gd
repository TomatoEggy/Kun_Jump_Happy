extends Control

@onready var new_record: Label = $VBoxContainer/NewRecord
@onready var quit_button: TextureButton = $VBoxContainer/HButtonsContainer/QuitButton
@onready var your_score: Label = $VBoxContainer/YourScore

func _ready() -> void:
	if OS.get_name() == "iOS":
		quit_button.visible = false
	
	if Game.ate_birthday_cake:
		new_record.visible = true
		new_record.text = "亻尔 吃 了 1 周 年 蛋 糕！"
	elif Game.score > Game.max_score:
		new_record.visible = true
		Game.max_score = Game.score
	your_score.text += str(Game.score)
	Game.save_data()


func _on_restart_button_up() -> void:
	Game.reset_game()
	Game.change_scene(Game.difficulty_scene)


func _on_quit_button_up() -> void:
	print("quit")
	Game.quit()
