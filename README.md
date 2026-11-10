# PixelPilot — Godot Developer Toolkit

A lightweight starter toolkit for Godot 4 projects. PixelPilot provides numbered-slot JSON saves, persistent audio/display settings, a runtime-built settings panel, and a small demo project.

## Features

- **SaveManager:** save, load, inspect, and delete numbered JSON save slots.
- **SettingsManager:** persist master volume, fullscreen, and VSync preferences.
- **Settings panel:** a minimal runtime-built UI you can theme and extend.
- **Demo project:** try the save/load and settings workflows.
- **No dependencies:** uses built-in Godot APIs.

## Requirements

- Godot 4.2 or newer (prototype checked with Godot 4.6.1).
- No third-party plugins or paid dependencies.

## Try the demo

1. Clone or download this repository.
2. Open the project folder in Godot.
3. Press F6/F5 (or Run Project) to launch the demo.
4. Change the score, save it to Slot 1, change it again, and load Slot 1.
5. Open Settings to try volume, fullscreen, and VSync.

## Installation in an existing project

1. Copy `addons/pixelpilot/` into your project's `res://addons/` directory.
2. In **Project → Project Settings → Globals → Autoload**, add:
   - Name: `SaveManager`; Path: `res://addons/pixelpilot/save_manager.gd`
   - Name: `SettingsManager`; Path: `res://addons/pixelpilot/settings_manager.gd`
3. Call the APIs from your scripts.

## Save and load

```gdscript
var player_data := {"level": 3, "coins": 125}
if SaveManager.save_game(1, player_data):
    print("Saved!")

var loaded_data: Dictionary = SaveManager.load_game(1)
print(loaded_data.get("level", 1))
```

Save files are stored under `user://pixelpilot_saves/`. Slot numbers start at 1. The manager checks the JSON structure and save version before returning data.

## Settings

```gdscript
SettingsManager.set_master_volume(0.65) # 0.0 to 1.0
SettingsManager.set_fullscreen(true)
SettingsManager.set_vsync_enabled(false)
```

Settings are stored in `user://pixelpilot_settings.cfg`. Audio control uses the default Godot bus named `Master`.

## Optional settings panel

Add a `Control` node and attach `addons/pixelpilot/settings_menu.gd`. Configure the `SettingsManager` autoload first. The panel creates its controls at runtime.

## Run the smoke test

From the project folder, run:

```powershell
& "C:\path\to\Godot.exe" --headless --path . --script res://tests/smoke_test.gd
```

The smoke test saves, reloads, inspects, and deletes a temporary save slot.

## Limitations

This is a starter kit, not a complete save-game architecture. Validate important game data in your own game code. Save migration, cloud sync, controller navigation, and platform-specific display behaviour should be tested in your target builds. The prototype has been checked with Godot 4.6.1; earlier Godot 4 versions and exported targets have not been fully verified.

## Licence

MIT. See [LICENSE](LICENSE).
