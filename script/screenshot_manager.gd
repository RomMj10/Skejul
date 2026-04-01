extends Node
 
## Save location : user://screenshots/
## File format   : screenshot_YYYY-MM-DD_HH-MM-SS.png
 
const SCREENSHOT_DIR := "user://screenshots"
 
# ---------------------------------------------------------------------------
# Public API
# ---------------------------------------------------------------------------
## Captures what the given Camera2D sees (no CanvasLayer UI) and saves to disk.
## Returns the full save path on success, or "" on failure.
func take_screenshot(camera: Camera2D) -> String:
	# Ensure output directory exists
	if not DirAccess.dir_exists_absolute(SCREENSHOT_DIR):
		var err := DirAccess.make_dir_recursive_absolute(SCREENSHOT_DIR)
		if err != OK:
			push_error("ScreenshotManager: Cannot create directory '%s' (error %d)" % [SCREENSHOT_DIR, err])
			return ""
 
	var image := await _capture_camera_view(camera)
	if image == null:
		return ""
 
	var save_path := _build_save_path()
	var err       := image.save_png(save_path)
	if err != OK:
		push_error("ScreenshotManager: Failed to save '%s' (error %d)" % [save_path, err])
		return ""
 
	print("ScreenshotManager: Screenshot saved → %s" % save_path)
	return save_path
 
# ---------------------------------------------------------------------------
# Internal helpers
# ---------------------------------------------------------------------------
 
func _build_save_path() -> String:
	var dt := Time.get_datetime_dict_from_system()
	var name := "screenshot_%04d-%02d-%02d_%02d-%02d-%02d.png" % [
		dt["year"], dt["month"],  dt["day"],
		dt["hour"], dt["minute"], dt["second"]
	]
	return "%s/%s" % [SCREENSHOT_DIR, name]
 
 
## Waits for the current frame to finish, then grabs the viewport texture.
## Because the camera lives in the root viewport (not a SubViewport) and the
## overlay UI is on a CanvasLayer, the viewport texture already represents the
## world view — CanvasLayer content is composited on top by the display server
## but is NOT baked into get_texture()'s Image on most platforms.
## We therefore just grab the full viewport image.
func _capture_camera_view(camera: Camera2D) -> Image:
	if not is_instance_valid(camera):
		push_error("ScreenshotManager: Camera2D reference is invalid.")
		return null
 
	var viewport: Viewport = camera.get_viewport()
	if viewport == null:
		push_error("ScreenshotManager: Camera has no viewport.")
		return null
 
	# Wait until the renderer has finished drawing this frame
	await RenderingServer.frame_post_draw
 
	var image: Image = viewport.get_texture().get_image()
	if image == null or image.is_empty():
		push_error("ScreenshotManager: Viewport returned an empty image.")
		return null
 
	return image
