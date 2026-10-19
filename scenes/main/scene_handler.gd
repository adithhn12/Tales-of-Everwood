extends Node

@export var main_menu_packed: PackedScene
@export var game_scene_packed: PackedScene


func _ready() -> void:
	load_main_menu("game_start")


func load_main_menu(origin: String) -> void:
	get_tree().paused = false

	var old_game = get_node_or_null("GameScene")
	if old_game:
		old_game.queue_free()
		await get_tree().process_frame

	var old_menu = get_node_or_null("MainMenu")
	if old_menu:
		old_menu.queue_free()
		await get_tree().process_frame

	var main_menu: Control = main_menu_packed.instantiate()
	main_menu.name = "MainMenu"

	main_menu.new_game_pressed.connect(new_game)
	main_menu.settings_pressed.connect(settings_open)
	main_menu.about_pressed.connect(about_open)
	main_menu.exit_pressed.connect(exit_game)

	add_child(main_menu)


func new_game(origin: String) -> void:
	get_tree().paused = false

	var old_game = get_node_or_null("GameScene")
	if old_game:
		old_game.queue_free()
		await get_tree().process_frame

	var old_menu = get_node_or_null("MainMenu")
	if old_menu:
		old_menu.queue_free()
		await get_tree().process_frame

	var game_scene: Node2D = game_scene_packed.instantiate()
	game_scene.name = "GameScene"
	add_child(game_scene)

	var pause_menu = game_scene.find_child("PauseMenu", true, false)

	if pause_menu:
		if not pause_menu.restart_game.is_connected(restart_from_pause):
			pause_menu.restart_game.connect(restart_from_pause)

		if not pause_menu.main_menu.is_connected(return_to_menu_from_pause):
			pause_menu.main_menu.connect(return_to_menu_from_pause)


func restart_from_pause() -> void:
	new_game("pause_menu")


func return_to_menu_from_pause() -> void:
	await load_main_menu("pause_menu")


func settings_open(_origin: String) -> void:
	pass


func about_open(_origin: String) -> void:
	pass


func exit_game(_origin: String) -> void:
	get_tree().quit()
