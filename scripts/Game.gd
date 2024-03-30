extends Node

## 分数变化时发出的信号
signal score_changed(changed_score)

## 存档文件路径
const DATA_FILE = "user://.data"

const BIRTHDAY_CAKE_SCORE: int = 50 - 1

const SOUNDS_BUS_INDEX: int = 2

## 游戏结束的场景
@export var game_over_scene: PackedScene

## 正常关卡的场景
@export var world_scene: PackedScene

## 主菜单场景
@export var main_menu_scene: PackedScene

## 设置菜单场景
@export var settings_menu_scene: PackedScene

## 选择难度场景
@export var difficulty_scene: PackedScene

## 游戏版本
var version = ProjectSettings.get_setting("application/config/version"):
	set(v):
		push_error("Cannot reset a readonly variable.")

## 当前得分
var score: int = 0:
	set(v):
		score = v
		score_changed.emit(score)
		
## 默认重力
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity"):
	set(v):
		push_error("Cannot reset a readonly variable.")

## 屏幕宽度
var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width"):
	set(v):
		push_error("Cannot reset a readonly variable.")
		
## 当前BGM
var bgm: AudioStream:
	set(v):
		if v == null:
			bgm_node.stop()
		else:
			bgm = v
			bgm_node.stream = bgm
			bgm_node.play()

## 玩家所得过的最大的分数
var max_score: int = 0

## 玩家是否吃了1周年蛋糕
var ate_birthday_cake: bool = false

## 游戏中的各种受难度影响数值
var variables: Dictionary = {
	"obstacle_range": 1,
	"create_obstacle_wait_time": 1.5,
	"initial_health": 3,
	"invincible_obstacle_num": 3,
	"invincible_chance": 0.1,
	"cake_chance": 0.1,
	"velocity": 300,
	"sun_force": Vector2(-380, -380),
}

@onready var bgm_node: AudioStreamPlayer = $BGM
@onready var sound_node: AudioStreamPlayer = $Sound

func _ready() -> void:
	# 设置窗口标题
	$"/root".title = "坤 坤 跳 跳 乐 %s"%version
	# 加载游戏数据
	bgm = load("res://assets/music/kunmusic.mp3")
	max_score = 0
	load_data()
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		quit()

func reset_game():
	score = 0
	bgm_node.play()

func game_over():
	change_scene(game_over_scene)

func change_scene(scene: PackedScene):
	get_tree().change_scene_to_packed(scene)

func play_sound(sound: AudioStream):
	sound_node.stream = sound
	sound_node.play()

func save_data() -> void:
	var data := {
		"bgm": bgm.resource_path,
		"max_score": max_score,
	}
	var json := JSON.stringify(data)
	
	var file := FileAccess.open(DATA_FILE, FileAccess.WRITE)
	if not file:
		return
	file.store_string(json)

func load_data() -> void:
	var file := FileAccess.open(DATA_FILE, FileAccess.READ)
	if not file:
		return
		
	var json := file.get_as_text()
	var data := JSON.parse_string(json) as Dictionary
	
	bgm = load(data["bgm"])
	max_score = data["max_score"]

func quit():
	save_data()
	print("quit")
	get_tree().quit()

func chance(percentage: float) -> bool:
	randomize()
	return randf() < percentage

func get_key_index(dict: Dictionary, key) -> int:
	var index: int = 0
	for k in dict.keys():
		if k == key:
			return index
		index += 1
	push_error("The dictionary has not the key. This function will return -1.")
	return -1
