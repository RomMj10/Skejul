extends Control

@onready var menubar = $header/menu_btn
@onready var color1 = $footer/ColorRect
@onready var color2 = $footer/ColorRect2
@onready var color3 = $footer/ColorRect3
@onready var title_lbl = $LineEdit

@onready var barcode = $footer/barcode
@onready var anim = $anim

@onready var draggable_block = preload("res://prefabs/draggable_block.tscn")
@onready var text_block = preload("res://prefabs/text_block.tscn")

var menu_on = false



func _on_menu_btn_button_up() -> void:
	anim.play("anim_action_up")
	menu_on = true


func _on_actionbar_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed && menu_on:
			anim.play_backwards("anim_action_up")
			anim.seek(0.48)
			menu_on = !menu_on


func _on_line_edit_text_changed(new_text: String) -> void:
	barcode.text = new_text


func _on_button_pressed() -> void:
	var new_block = draggable_block.instantiate()
	new_block.global_position = Vector2(96, 96)
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
	new_text.global_position = Vector2(96, 96)
	get_tree().current_scene.add_child(new_text)
