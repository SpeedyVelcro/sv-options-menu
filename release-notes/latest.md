- The `VolumeSettingsUI` scene now has exported properties for changing
  mute button styling: `mute_button_custom_minimum_size` and
  `mute_button_expand_icon`.
- You can now set a different default window mode from the project
  settings by using `OptionsConfig.default_window_mode`.
- Fixed UI scale slider clamping loaded value incorrectly.
- UI scaling properly responds to window size changes when manage
  resolution is off.
- `UIScalingSubViewport` no longer loses its connections if you change
  the local options on `OptionsProvider`, or instantiate it before
  calling `start_up()`.
- Fixed default UI scale not calculating correctly.
- Improved controller/keyboard navigability for combo sliders.
- Combo sliders now update their value correctly when modifying them
  using controller/keyboard. 
- Added manage VSync mode capability
- Update `README.md` install instructions to direct users to releases
  page.
- Copied LICENSE file to addon directory.

