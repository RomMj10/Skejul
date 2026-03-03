extends Control

var group = ""
var editing = false
var dragged = false
var drag_offset = Vector2.ZERO
@onready var bg_panel = $panel
@onready var icon = $vbox/Control/icon
@onready var group_panel = $vbox/Control/option
@onready var config_panel = $config_panel
@onready var time_lbl = $vbox/time_lbl
@onready var course_lbl = $vbox/course_lbl
@onready var room_lbl = $room_lbl

func _ready() -> void:
	group_panel.hide()
	config_panel.hide()
	bg_panel.modulate = Global.color_group[group_panel.selected]

func _on_option_item_selected(index: int) -> void:
	group = index
	group_panel.visible = false

func _on_panel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		dragged = event.pressed
		drag_offset = (get_global_mouse_position() - global_position)
	if event is InputEventMouseMotion:
		if dragged:
			self.position = get_global_mouse_position()

func _physics_process(delta: float) -> void:
	if bg_panel.modulate != Global.color_group[group_panel.selected]:
		bg_panel.modulate = Global.color_group[group_panel.selected]
		time_lbl.modulate = get_contrast_color(bg_panel.modulate)
		course_lbl.modulate = get_contrast_color(bg_panel.modulate)
		course_lbl.modulate.a =0.75
		room_lbl.modulate = get_contrast_color(bg_panel.modulate)
		icon.texture = load(Global.icon_group[group_panel.selected])

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_pressed("ui_accept"):
			dragged = false
			return
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && !editing:
			dragged = event.pressed
			drag_offset = (get_global_mouse_position() - global_position)
		elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			dragged = false
			if !editing:
				editing = true
				config_panel.visible = true
			else:
				editing = false
				config_panel.visible = false
		else:
			dragged = false
	if event is InputEventMouseMotion:
		if dragged:
			var target_pos = get_global_mouse_position() - drag_offset
			target_pos.x = round(target_pos.x / 32) * 32
			target_pos.y = round(target_pos.y / 32) * 32
			global_position = target_pos
	


func _on_icon_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			group_panel.visible = !group_panel.visible
			

func get_contrast_color(bg: Color) -> Color:
	var luminance = (0.299 * bg.r) + (0.587 * bg.g) + (0.114 * bg.b)
	if luminance > 0.5:
		return Color.BLACK
	else:
		return  Color.WHITE

func _on_remove_btn_pressed() -> void:
	queue_free()


func _on_line_edit_time_text_changed(new_text: String) -> void:
	time_lbl.text = new_text

func _on_line_edit_course_text_changed(new_text: String) -> void:
	course_lbl.text = new_text


func _on_line_edit_room_text_changed(new_text: String) -> void:
	room_lbl.text = new_text
