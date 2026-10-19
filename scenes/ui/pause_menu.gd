
extends Control

signal resume_game
signal restart_game
signal main_menu

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			get_tree().paused = false
			hide()
		else:
			show()
			get_tree().paused = true

		get_viewport().set_input_as_handled()

func _on_resume_pressed() -> void:
	get_tree().paused = false
	hide()

func _on_restart_pressed() -> void:
	get_tree().paused = false
	restart_game.emit()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	main_menu.emit()
