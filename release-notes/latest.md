### Features
- Added `OptionAccessor` a node that tracks a specific option (as
  specified by `option_path`), making it easy to create new option
  controls.
- Added `OptionCheckButton` node, a `CheckButton` that tracks and changes a
  configured option.
- Added `OptionCheckBox` node.
- Added `OptionLineEdit` node.
- Added `OptionTextEdit` node.
- Added `OptionOptionButton` node.
- Added `OptionSpinBox` node.
- Added `OptionHSlider` node.
- Added `OptionVSlider` node.
- Added `OptionColorPickerButton` node.
- Added `OptionColorPicker` node.
- Added `OptionComboSlider` scene.
- `OptionsConfig.custom_default_options` now accepts a `Dictionary`
  instead of a `GameOptions`. This should make it easier to edit in
  the inspector.

### Example Game
- Added player color setting, which demonstrates the
  `OptionOptionButton` node.

### Breaking Changes
- `OptionsConfig.custom_default_options` is now a dictionary with the
  keys being option paths and the values being the default value of
  each option. If you set a custom `GameOptions`, it will likely be
  lost when upgrading.

