extends Control

signal new_game_pressed(origin: String)
signal settings_pressed(origin: String)
signal about_pressed(origin: String)
signal exit_pressed(origin: String)

func _on_new_game_pressed() -> void:
	new_game_pressed.emit("main_menu")

func _on_settings_pressed() -> void:
	settings_pressed.emit("main_menu")

func _on_about_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/about.tscn")

func _on_exit_pressed() -> void:
	exit_pressed.emit("main_menu")
