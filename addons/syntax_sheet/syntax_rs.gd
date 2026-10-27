@tool
extends EditorPlugin

var panel : Control = null

func _enter_tree():
	# Load texture safely
	var image = Image.new()
	var err = image.load("res://addons/syntax_sheet/syntax.webp")
	if err != OK:
		printerr("Failed to load keybinds image!")
		return
	var texture = ImageTexture.create_from_image(image)

	# Create scrollable panel
	var scroll = ScrollContainer.new()
	scroll.name = "Syntax"
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var tex_rect = TextureRect.new()
	tex_rect.texture = texture
	tex_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	tex_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tex_rect.size_flags_vertical = Control.SIZE_EXPAND_FILL

	scroll.add_child(tex_rect)
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, scroll)
	panel = scroll

func _exit_tree():
	if panel:
		remove_control_from_docks(panel)
		panel.queue_free()
