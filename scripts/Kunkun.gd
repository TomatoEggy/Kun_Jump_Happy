## 玩家的角色——坤坤

class_name KunKun
extends CharacterBody2D

## 状态
enum State {
	IDLE,
	JUMP,
	FALL,
	SQUAT,
	INVINCIBLE,
}

const SOUNDS: Dictionary = {
	gameover = preload("res://assets/sounds/gameover.wav"),
	hurt = preload("res://assets/sounds/hurt.wav"),
	jump = preload("res://assets/sounds/jump.wav")
}

## 跳跃速度
const JUMP_VELOCITY: float = 600.0

## 碰撞时的短暂无敌时间
const COLLIDE_TIME: float = 0.01

## 血量变化时发出的信号
signal health_changed(changed_health)

@onready var invincible_timer: Timer = $InvincibleTimer
@onready var anim_player: AnimationPlayer = $AnimationPlayer

@onready var ready_pos := position

## 初始血量
var initial_health: int = Game.variables["initial_health"]

## 正常的无敌时间
var invincible_time: float = Game.variables["invincible_obstacle_num"] * Game.variables["create_obstacle_wait_time"]

## 当前血量
var current_health: int = initial_health:
	set(v):
		current_health = v
		health_changed.emit(current_health)

## 当前状态
var current_state: State = State.IDLE:
	set(v):
		if v != current_state:
			play_animation(v)
			change_state(v)
		current_state = v

## 是否跳跃
var should_jump: bool = false

## 是否下蹲
var should_squat: bool = false

## 是否应当进入无敌状态
var should_invincible: bool = false

func _ready() -> void:
	invincible_timer.wait_time = invincible_time

func _unhandled_input(event: InputEvent) -> void:
	# 按键事件(针对桌面平台)
	if event is InputEventKey:
		if event.is_action_pressed("jump") and is_on_floor():
			should_jump = true
		if event.is_action_pressed("squat") and is_on_floor():
			should_squat = true
		if event.is_action_released("jump"):
			should_jump = false
		if event.is_action_released("squat"):
			should_squat = false
	
	# 触摸事件(针对移动平台)
	if event is InputEventScreenTouch:
		if event.pressed == true:
			if event.position.x <= Game.screen_width / 2 and is_on_floor():
				should_squat = true
			if event.position.x > Game.screen_width / 2 and is_on_floor():
				should_jump = true
		else:
			if event.position.x <= Game.screen_width / 2:
				should_squat = false
			if event.position.x > Game.screen_width / 2:
				should_jump = false

func _physics_process(_delta: float) -> void:
	if position.x != ready_pos.x:
		position.x = ready_pos.x
	
	move_and_slide()
	
func _process(_delta: float) -> void:
	current_state = next_state(current_state)
	if current_health <= 0:
		Game.bgm = null
		Game.play_sound(SOUNDS.gameover)
		Game.change_scene(Game.game_over_scene)

## 应当的下一个状态(状态机函数)
func next_state(state: State) -> State:
	if should_invincible and current_state != State.INVINCIBLE:
		return State.INVINCIBLE
		
	match state:
		State.IDLE:
			# 起跳
			if should_jump:
				return State.JUMP
			# 下蹲
			if should_squat:
				return State.SQUAT
			# 突然下落
			if not is_on_floor():
				return State.FALL
				
		State.JUMP:
			# 下落
			if position.y <= 50:
				return State.FALL
				
		State.FALL:
			# 落地
			if is_on_floor():
				return State.IDLE
				
		State.SQUAT:
			# 站立
			if not should_squat:
				return State.IDLE
				
		State.INVINCIBLE:
			should_squat = false
			if invincible_timer.is_stopped():
				should_invincible = false
				invincible_timer.wait_time = invincible_time
				return State.IDLE
				
	return state
	
## 切换状态时的回调(状态机函数)
func change_state(state: State):
	match state:
		State.JUMP:
			Game.play_sound(SOUNDS.jump)
			velocity.y = -JUMP_VELOCITY
		State.FALL:
			velocity.y = JUMP_VELOCITY
		State.INVINCIBLE:
			velocity.y = 0
			position.y = ready_pos.y
			invincible_timer.start()

## 根据状态播放动画(状态机函数)
func play_animation(state: State):
	match state:
		State.IDLE:
			anim_player.play("idle")
		State.JUMP:
			anim_player.play("jump")
		State.SQUAT:
			anim_player.play("squat")
		State.INVINCIBLE:
			anim_player.play("invincible")

func connect_obstacle_signal(obstacle: Obstacle):
	obstacle.collided.connect(collide_obstacle)
	obstacle.destoryed.connect(add_score)

func collide_obstacle(source: Obstacle):
	if not source.not_hurt and current_state != State.INVINCIBLE:
		invincible_timer.wait_time = COLLIDE_TIME
		Game.play_sound(SOUNDS.hurt)
		current_health -= 1
		should_invincible = true
	if source.not_hurt:
		if source is Basketball:
			should_invincible = true
		if source is Cake and current_state != State.INVINCIBLE:
			current_health += 1
		if source is BirthdayCake:
			Game.score += 1
			current_health += 1
			Game.ate_birthday_cake = true

	if current_state == State.INVINCIBLE:
		add_score(source)

func add_score(source: Obstacle):
	if not((source is Cake) and (source.not_hurt)):
		if Game.ate_birthday_cake:
			Game.score *= randi_range(2, 3)
		else:
			Game.score += 1
