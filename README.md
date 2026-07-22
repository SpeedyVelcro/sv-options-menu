# SV Options Menu
Utilities for setting up an options menu in your Godot game. Currently
usable but still in an unpolished state, so you might need to wrangle
it to fit into your project.

![Screenshot of some controls from SV Options Menu](./readme-screenshot.png)

## Installation
- SV Options Menu requires [Godot 4.7](https://godotengine.org/download/4.x)
- Download the archive `sv-options-menu-addon-vX.X.X.zip` from the
  [latest release page](https://github.com/SpeedyVelcro/sv-options-menu/releases/latest).
- Extract the archive into the root directory of your project (i.e. the
  same folder as your `project.godot` file).
- Activate the plugin in Project Settings.

## Usage
- Configure SV Options Menu by editing the newly created
  `options_config.tres` in your project root.
- For managed settings, place settings UI scenes from the addon's
  folders to your game's options menu.
- An example of usage is seen in the Godot project at the root of this
  repository.

## License
See the [LICENSE](./LICENSE) file. Note that this repo also contains
third party dev dependencies that have their own licenses. These can
be found in the following files:
```
addons/gdUnit4/LICENSE
```
