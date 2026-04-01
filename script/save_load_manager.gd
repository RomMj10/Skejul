extends Node
 
## Save format : JSON  |  Extension : .essen
 
const FILE_EXT := ".essen"
const VERSION  := 1
 
const TYPE_DRAGGABLE := "draggable_block"
const TYPE_TEXT      := "text_block"
 
const DRAGGABLE_SCENE := preload("res://prefabs/draggable_block.tscn")
const TEXT_SCENE      := preload("res://prefabs/text_block.tscn")
 
# ---------------------------------------------------------------------------
# SAVE
# ---------------------------------------------------------------------------
func save_scene(scene_root: Node, path: String) -> bool:
	if not path.ends_with(FILE_EXT):
		path += FILE_EXT
 
	var blocks := []
	for child in scene_root.get_children():
		var entry := _serialize_node(child)
		if not entry.is_empty():
			blocks.append(entry)
 
	var data := {
		"title" : scene_root.get_node("overlay/header/LineEdit").text,
		"version" : VERSION,
		"cam_pos" : _v2a(scene_root.get_node("cam").position),
		"blocks"  : blocks,
	}
 
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("SaveLoadManager: Cannot write to '%s'" % path)
		return false
 
	file.store_string(JSON.stringify(data, "\t"))
	file.close()
	print("SaveLoadManager: Saved → %s" % path)
	return true
 
# ---------------------------------------------------------------------------
# LOAD
# ---------------------------------------------------------------------------
## Call with the path returned by FileDialog's file_selected signal.
func load_scene(scene_root: Node, path: String) -> bool:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("SaveLoadManager: Cannot read '%s'" % path)
		return false
 
	var json := JSON.new()
	var err  := json.parse(file.get_as_text())
	file.close()
 
	if err != OK:
		push_error("SaveLoadManager: JSON parse error – %s" % json.get_error_message())
		return false
 
	var data : Dictionary = json.get_data()
 
	_clear_blocks(scene_root)
 
	if data.has("cam_pos"):
		var pos := _a2v(data["cam_pos"])
		var title = data["title"]
		scene_root.get_node("cam").position = pos
		scene_root.target_camera_pos        = pos
		scene_root.get_node("overlay/header/LineEdit").text = title
 
	for entry in data.get("blocks", []):
		_deserialize_node(scene_root, entry)
 
	print("SaveLoadManager: Loaded ← %s" % path)
	return true
 
# ---------------------------------------------------------------------------
# Serialization
# ---------------------------------------------------------------------------
func _serialize_node(node: Node) -> Dictionary:
	match _script_class(node):
		TYPE_DRAGGABLE:
			return {
				"type"         : TYPE_DRAGGABLE,
				"position"     : _v2a(node.global_position),
				"size"         : _v2a(node.size),
				"time"         : node.get_node("vbox/time_lbl").text,
				"course"       : node.get_node("vbox/course_lbl").text,
				"room"         : node.get_node("room_lbl").text,
				"color_group"  : node.get_meta("color_group", 0),
				"option_index" : node.get_node("vbox/Control/option").selected,
			}
		TYPE_TEXT:
			return {
				"type"       : TYPE_TEXT,
				"position"   : _v2a(node.global_position),
				"text"       : node.get_node("LineEdit").text,
				"font_color" : _c2a(node.get_node("LineEdit/font_color").color),
				"bg_color"   : _c2a(node.get_node("LineEdit/bg_color").color),
			}
	return {}
 
 
func _deserialize_node(scene_root: Node, e: Dictionary) -> void:
	match e.get("type", ""):
		TYPE_DRAGGABLE:
			var b := DRAGGABLE_SCENE.instantiate()
			scene_root.add_child(b)
			b.global_position                          = _a2v(e["position"])
			if e.has("size"): b.size                  = _a2v(e["size"])
			b.get_node("vbox/time_lbl").text           = e.get("time",   "")
			b.get_node("vbox/course_lbl").text         = e.get("course", "")
			b.get_node("room_lbl").text                = e.get("room",   "")
			b.get_node("vbox/Control/option").select(e.get("option_index", 1))
			b.set_meta("color_group", e.get("color_group", 0))
		TYPE_TEXT:
			var b := TEXT_SCENE.instantiate()
			scene_root.add_child(b)
			b.global_position                        = _a2v(e["position"])
			b.get_node("LineEdit").text              = e.get("text", "")
			b.get_node("LineEdit/font_color").color  = _a2c(e.get("font_color", [1,1,1,1]))
			b.get_node("LineEdit/bg_color").color    = _a2c(e.get("bg_color",   [1,1,1,1]))
 
 
func _clear_blocks(scene_root: Node) -> void:
	for child in scene_root.get_children():
		if _script_class(child) in [TYPE_DRAGGABLE, TYPE_TEXT]:
			child.queue_free()
 
# ---------------------------------------------------------------------------
# Utilities
# ---------------------------------------------------------------------------
func _script_class(node: Node) -> String:
	var s = node.get_script()
	return s.resource_path.get_file().get_basename() if s else ""
 
func _v2a(v: Vector2) -> Array: return [v.x, v.y]
func _a2v(a: Array)   -> Vector2: return Vector2(a[0], a[1])
func _c2a(c: Color)   -> Array: return [c.r, c.g, c.b, c.a]
func _a2c(a: Array)   -> Color: return Color(a[0], a[1], a[2], a[3])
