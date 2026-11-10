# PixelPilot

A small Godot 4 starter toolkit for numbered JSON save slots and persistent player settings.

## Installation

1. Copy the `pixelpilot` folder into your project's `res://addons/` directory.
2. In Project > Project Settings > Globals > Autoload, add:
   - `SaveManager` → `res://addons/pixelpilot/save_manager.gd`
   - `SettingsManager` → `res://addons/pixelpilot/settings_manager.gd`
3. See the root README for API examples and limitations.

## Compatibility

The prototype has been checked with Godot 4.6.1 using headless project validation and a save/load smoke test. Compatibility with earlier Godot 4 versions and exported targets has not yet been verified.

## Licence

MIT. See the root LICENSE file.
