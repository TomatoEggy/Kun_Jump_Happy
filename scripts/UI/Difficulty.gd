extends Control

func _on_easy_button_up() -> void:
	# 简单难度数值
	Game.variables = {
		"obstacle_range": 8,
		"create_obstacle_wait_time": 1.75,
		"initial_health": 5,
		"invincible_obstacle_num": 5,
		"invincible_chance": 0.15,
		"cake_chance": 0.15,
		"velocity": 350,
		"sun_force": Vector2(-380, -380),
	}
	start_game()

func _on_medium_button_up() -> void:
	# 中等难度数值
	Game.variables = {
		"obstacle_range": 6,
		"create_obstacle_wait_time": 1.15,
		"initial_health": 3,
		"invincible_obstacle_num": 3,
		"invincible_chance": 0.06,
		"cake_chance": 0.04,
		"velocity": 520,
		"sun_force": Vector2(-480, -380),
	}
	start_game()

func _on_hard_button_up() -> void:
	# 困难难度数值
	Game.variables = {
		"obstacle_range": 4,
		"create_obstacle_wait_time": 1,
		"initial_health": 2,
		"invincible_obstacle_num": 1,
		"invincible_chance": 0.01,
		"cake_chance": 0.01,
		"velocity": 660,
		"sun_force": Vector2(-650, -380),
	}
	start_game()

func _on_hell_button_up() -> void:
	# 地狱难度数值
	Game.variables = {
		"obstacle_range": 3,
		"create_obstacle_wait_time": 0.7,
		"initial_health": 1,
		"invincible_obstacle_num": 1,
		"invincible_chance": 0,
		"cake_chance": 0,
		"velocity": 850,
		"sun_force": Vector2(-800, -380),
	}
	start_game()

func start_game() -> void:
	Game.change_scene(Game.world_scene)
