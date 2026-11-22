### Features
- Added `OptionAccessor` a node that tracks a specific option (as
  specified by `option_path`), making it easy to create new option
  controls.
- Added `OptionCheckButton`, a `CheckButton` that tracks and changes a
  configured option.
- Added `OptionCheckBox`
- Added `OptionLineEdit`
- `OptionsConfig.custom_default_options` now accepts a `Dictionary`
  instead of a `GameOptions`. This should make it easier to edit in
  the inspector.

### Breaking Changes
- `OptionsConfig.custom_default_options` is now a dictionary with the
  keys being option paths and the values being the default value of
  each option. If you set a custom `GameOptions`, it will likely be
  lost when upgrading.

