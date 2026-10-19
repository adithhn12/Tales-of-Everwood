extends Control

@onready var background: TextureRect = $Background
@onready var panel: PanelContainer = $CenterContainer/Panel
@onready var vbox: VBoxContainer = $CenterContainer/Panel/VBoxContainer
@onready var title_label: Label = $CenterContainer/Panel/VBoxContainer/Title
@onready var description_label: Label = $CenterContainer/Panel/VBoxContainer/Description
@onready var credits_label: Label = $CenterContainer/Panel/VBoxContainer/Credits
@onready var back_button: Button = $CenterContainer/Panel/VBoxContainer/BackButton


func _ready() -> void:
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE

	panel.custom_minimum_size = Vector2(650, 0)
	panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER

	vbox.add_theme_constant_override("separation", 10)

	# Panel styling
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.055, 0.075, 0.085, 0.96)
	panel_style.border_color = Color(0.78, 0.66, 0.39, 1.0)
	panel_style.set_border_width_all(3)
	panel_style.set_corner_radius_all(12)
	panel_style.set_content_margin_all(20)
	panel.add_theme_stylebox_override("panel", panel_style)

	# Title
	title_label.text = "TALES OF EVERWOOD"
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 28)
	title_label.add_theme_color_override(
		"font_color", Color(1.0, 0.84, 0.53)
	)

	# Introduction
	description_label.text = (
		"\nA world of mystery awaits beyond the forest.\n"
		+ "Explore forgotten ruins, battle dangerous enemies, "
		+ "and uncover the secrets of Everwood."
	)
	_style_body(description_label, 15)

	# Objective
	var objective_heading := _create_heading("\nYOUR QUEST")
	vbox.add_child(objective_heading)
	vbox.move_child(objective_heading, description_label.get_index() + 1)

	var objective_text := Label.new()
	objective_text.text = (
		"Defeat all enemies scattered across the map "
		+ "to complete the level.\n"
		+ "Earn EXP by defeating enemies and level up "
		+ "to increase your sword attack speed."
	)
	_style_body(objective_text, 15)
	vbox.add_child(objective_text)
	vbox.move_child(objective_text, objective_heading.get_index() + 1)

	# Controls
	var controls_heading := _create_heading("\nCONTROLS")
	vbox.add_child(controls_heading)

	_add_control_row("W  A  S  D", "Move")
	_add_control_row("SPACE", "Attack with your sword")
	_add_control_row("ESC", "Pause / resume")
	# Move Back to Menu below all controls
	vbox.move_child(back_button, -1)

	# Credits
	credits_label.text = "\nDEVELOPED BY ADITH H N  |  VERSION 1.0\n"
	credits_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	credits_label.add_theme_font_size_override("font_size", 12)
	credits_label.add_theme_color_override(
		"font_color", Color(0.75, 0.78, 0.72)
	)

	# Back button
	back_button.text = "←  BACK TO MENU"
	back_button.custom_minimum_size = Vector2(360, 80)
	back_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	back_button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	back_button.add_theme_font_size_override("font_size", 26)

	var normal := StyleBoxFlat.new()
	normal.bg_color = Color(0.17, 0.22, 0.21, 1.0)
	normal.border_color = Color(0.78, 0.66, 0.39, 1.0)
	normal.set_border_width_all(2)
	normal.set_corner_radius_all(8)
	normal.set_content_margin_all(8)

	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = Color(0.29, 0.36, 0.29, 1.0)

	var pressed_style := normal.duplicate() as StyleBoxFlat
	pressed_style.bg_color = Color(0.10, 0.14, 0.13, 1.0)

	back_button.add_theme_stylebox_override("normal", normal)
	back_button.add_theme_stylebox_override("hover", hover)
	back_button.add_theme_stylebox_override("pressed", pressed_style)

	if not back_button.pressed.is_connected(_on_back_button_pressed):
		back_button.pressed.connect(_on_back_button_pressed)
		
	# Keep credits immediately above Back to Menu
	vbox.move_child(credits_label, back_button.get_index())
	vbox.move_child(back_button, -1)


func _create_heading(text_value: String) -> Label:
	var heading := Label.new()
	heading.text = text_value
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.add_theme_font_size_override("font_size", 17)
	heading.add_theme_color_override(
		"font_color", Color(1.0, 0.84, 0.53)
	)
	return heading


func _style_body(label: Label, font_size: int) -> void:
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override(
		"font_color", Color(0.91, 0.92, 0.87)
	)


func _add_control_row(key_text: String, action_text: String) -> void:
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 14)

	var key_label := Label.new()
	key_label.text = key_text
	key_label.custom_minimum_size = Vector2(100, 30)
	key_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	key_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	key_label.add_theme_font_size_override("font_size", 13)
	key_label.add_theme_color_override(
		"font_color", Color(1.0, 0.84, 0.53)
	)

	var key_style := StyleBoxFlat.new()
	key_style.bg_color = Color(0.17, 0.22, 0.21, 1.0)
	key_style.border_color = Color(0.45, 0.52, 0.46, 1.0)
	key_style.set_border_width_all(1)
	key_style.set_corner_radius_all(5)
	key_label.add_theme_stylebox_override("normal", key_style)

	var action_label := Label.new()
	action_label.text = action_text
	action_label.custom_minimum_size = Vector2(210, 30)
	action_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	action_label.add_theme_font_size_override("font_size", 13)
	action_label.add_theme_color_override(
		"font_color", Color(0.91, 0.92, 0.87)
	)

	row.add_child(key_label)
	row.add_child(action_label)
	vbox.add_child(row)


func _on_back_button_pressed() -> void:
	var error := get_tree().change_scene_to_file(
		"res://scenes/main/scene_handler.tscn"
	)

	if error != OK:
		push_error("Could not load scene_handler.tscn. Check the scene path.")
