extends VBoxContainer

const HEALTH_TEXT: StringName = "你的血量: "
const SCORE_TEXT: StringName = "你的得分: "

## 坤坤(玩家)节点
@export var kunkun: KunKun

@onready var score: Label = $Score
@onready var health: Label = $Health

func _ready() -> void:
	kunkun.health_changed.connect(update_health)
	Game.score_changed.connect(update_score)
	
	update_health(kunkun.current_health)
	update_score(Game.score)

func update_health(player_health: int):
	health.text = HEALTH_TEXT + str(player_health)
	
func update_score(player_score: int):
	score.text = SCORE_TEXT + str(player_score)
