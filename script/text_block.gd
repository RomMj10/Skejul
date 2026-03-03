extends Control


@onready var lineEdit = $LineEdit
@onready var font_color = $LineEdit/font_color
@onready var bg_color = $LineEdit/bg_color
@onready var draggable = false
var drag_offset = Vector2.ZERO

func _ready() -> void:
	font_color.color = Color(1.0, 1.0, 1.0, 1.0)
	bg_color.color = Color(0.0, 0.0, 0.0, 0.529)
	update_colors()


func update_colors():
	lineEdit.add_theme_color_override("font_color", font_color.color)
	var new_stylebox = StyleBoxFlat.new()
	new_stylebox.set_corner_radius_all(8)
	new_stylebox.set_content_margin_all(8)
	new_stylebox.bg_color = bg_color.color
	lineEdit.add_theme_stylebox_override("normal", new_stylebox)
	lineEdit.add_theme_stylebox_override("read_only", new_stylebox)
	lineEdit.add_theme_stylebox_override("focus", new_stylebox)
	lineEdit.add_theme_color_override("font_uneditable_color", font_color.color)



func _on_line_edit_text_changed(new_text: String) -> void:
	#if new_text == "":
	#	queue_free()
	pass



func _on_font_color_color_changed(color: Color) -> void:
	lineEdit.add_theme_color_override("font_color", font_color.color)
	lineEdit.add_theme_color_override("font_uneditable_color", font_color.color)


func _on_bg_color_color_changed(color: Color) -> void:
	var new_stylebox = StyleBoxFlat.new()
	new_stylebox.set_corner_radius_all(8)
	new_stylebox.set_content_margin_all(8)
	new_stylebox.bg_color = bg_color.color
	lineEdit.add_theme_stylebox_override("normal", new_stylebox)
	lineEdit.add_theme_stylebox_override("read_only", new_stylebox)
	lineEdit.add_theme_stylebox_override("focus", new_stylebox)


func _on_line_edit_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			draggable = !draggable
		if draggable:
			font_color.visible = false
			bg_color.visible = false
			lineEdit.editable = false
			lineEdit.mouse_default_cursor_shape = Control.CURSOR_DRAG
			lineEdit.selecting_enabled = false
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				drag_offset = (get_window().get_mouse_position() - global_position)
			
		else:
			lineEdit.mouse_default_cursor_shape = Control.CURSOR_IBEAM
			lineEdit.selecting_enabled = true
			lineEdit.editable = true
			font_color.visible = true
			bg_color.visible = true
	if event is InputEventMouseMotion && Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if draggable:
			var target_pos = get_global_mouse_position() - drag_offset
			target_pos.x = round(target_pos.x / 32) * 32
			target_pos.y = round(target_pos.y / 32) * 32
			global_position = target_pos


func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text == "":
		queue_free()
