The headline feature of this release is controller glyphs. You can now
display pictographic representations of joypad controls instead of
long strings like "Left Thumbstick Up" or whatever it was. The addon
comes with a default set of icons that I made in Inkscape, which are
covered by the same license as the rest of the repository. Of course,
you are free to replace these.

### Features
- Binding buttons in options menu now show glyphs when bound to certain
  events such as controller buttons. These glyphs are customisable in
  OptionsConfig.
- New utilities added on the new `GlyphProvider` autoload for getting
  glyphs and BBCode corresponding to the player's input setting. These
  are used for a tutorial dialog in the example game.
- The `InputMapSettingsUI` scene now has exported properties for
  changing add and delete button styling:
  `icon_button_custom_minimum_size` and `icon_button_expand_icon`.
- The `VolumeSettingsUI` scene now has exported properties for changing
  mute button styling: `mute_button_custom_minimum_size` and
  `mute_button_expand_icon`.
- You can now set a different default window mode from the project
  settings by using `OptionsConfig.default_window_mode`.
- Improved controller/keyboard navigability for combo sliders.
- Added manage VSync mode capability

### Fixes
- The binding buton under InputEventEditor scenes now has more
  consistent scaling for locked input actions where the delete button
  isn't shown.
- Fixed UI scale slider clamping loaded value incorrectly.
- UI scaling properly responds to window size changes when manage
  resolution is off.
- `UIScalingSubViewport` no longer loses its connections if you change
  the local options on `OptionsProvider`, or instantiate it before
  calling `start_up()`.
- Fixed default UI scale not calculating correctly.
- Combo sliders now update their value correctly when modifying them
  using controller/keyboard. 

### Documentation
- Update `README.md` install instructions to direct users to releases
  page.
- Copied LICENSE file to addon directory.

