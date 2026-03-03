extends Control

@onready var menubar = $header/menu_btn
@onready var color1 = $overlay/footer/ColorRect
@onready var color2 = $overlay/footer/ColorRect2
@onready var color3 = $overlay/footer/ColorRect3
@onready var title_lbl = $overlay/header/LineEdit

@onready var barcode = $overlay/footer/barcode
@onready var anim = $anim
@onready var camera = $cam

const draggable_block = preload("res://prefabs/draggable_block.tscn")
const text_block = preload("res://prefabs/text_block.tscn")

var menu_on := false

var dragging := false
var drag_start_mouse := Vector2.ZERO
var drag_start_camera := Vector2.ZERO
var target_camera_pos := Vector2.ZERO

@export var drag_smoothness := 2.0

func _on_menu_btn_button_up() -> void:
	anim.play("anim_action_up")
	menu_on = true


func _on_line_edit_text_changed(new_text: String) -> void:
	barcode.text = new_text


func _on_button_pressed() -> void:
	var new_block = draggable_block.instantiate()
	new_block.global_position = camera.global_position
	get_tree().current_scene.add_child(new_block)

func _ready() -> void:
	Global.color_group[0] = color1.color
	Global.color_group[1] = color2.color
	Global.color_group[2] = color3.color


func _on_color_rect_color_changed(color: Color) -> void:
	Global.color_group[0] = color

func _on_color_rect_2_color_changed(color: Color) -> void:
	Global.color_group[1] = color

func _on_color_rect_3_color_changed(color: Color) -> void:
	Global.color_group[2] = color


func _on_button_2_pressed() -> void:
	var new_text = text_block.instantiate()
	new_text.global_position = camera.global_position
	get_tree().current_scene.add_child(new_text)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed && menu_on && event.button_index == MOUSE_BUTTON_LEFT:
			anim.play_backwards("anim_action_up")
			anim.seek(0.48)
			menu_on = !menu_on
			title_lbl.release_focus()
		if Input.is_action_pressed("ui_accept"):
			mouse_default_cursor_shape = Control.CURSOR_MOVE
			if event.button_index == MOUSE_BUTTON_LEFT:
				print(target_camera_pos)
				if event.pressed:
					dragging = true
					drag_start_mouse = get_viewport().get_mouse_position()
					drag_start_camera = camera.position
					print(drag_start_camera, drag_start_mouse)
					title_lbl.release_focus()
				else:
					dragging = false
		else:
			mouse_default_cursor_shape = Control.CURSOR_ARROW
			dragging = false
	elif event is InputEventMouseMotion && dragging:
		var mouse_delta = get_viewport().get_mouse_position() - drag_start_mouse
		target_camera_pos = drag_start_camera - mouse_delta

func _process(delta: float) -> void:
	camera.position = camera.position.lerp(target_camera_pos, drag_smoothness * delta)
	camera.position.x = clamp(camera.position.x, -1200, 1200)
	camera.position.y = clamp(camera.position.y, -800, 800)
