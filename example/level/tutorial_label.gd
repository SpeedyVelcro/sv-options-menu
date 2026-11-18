extends RichTextLabel


# Override
func _ready() -> void:
	_update_text()
	GlyphProvider.connect("action_glyphs_changed", _on_glyph_provider_action_glyphs_changed)


# Override
func _exit_tree() -> void:
	GlyphProvider.disconnect("action_glyphs_changed", _on_glyph_provider_action_glyphs_changed)


func _update_text() -> void:
	text = "Press %s to jump." % GlyphProvider.get_action_glyph_bbcode("jump")


# Signal connection
func _on_glyph_provider_action_glyphs_changed() -> void:
	_update_text()
