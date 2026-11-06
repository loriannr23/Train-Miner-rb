# Train Miner Roblox prototype

This repository holds the Luau gameplay source, the Blender source project, exported original FBX models, and the selected Kenney CC0 OGG clips.

## Prototype loop

- A 3-car locomotive follows a server-owned loop through a 99-tile forest plot.
- Trees, rocks, and crystals have health and visible damage stages. The final stump/rubble/cracked stage remains until the next lap collects its drop.
- The haul sells at Pine Junction. Coins and XP unlock saw rolls; two matching saws merge, and the best owned saw can be equipped.
- The Sawmill processes three collected wood into one plank at sale. Planks and coins build themed town buildings: a Bank for coin value, a Gym for train speed, and a Crystal Casino for improved high-tier saw odds.
- The HUD includes Diorama, Third Person, and First Person camera modes and targets landscape mobile screens.

## Source layout

- `src/shared/GameConfig.luau`: resource health, saw tiers, costs, and buildings.
- `src/server/`: server-owned movement, gathering, selling, rolls, merging, and building.
- `src/client/`: camera controls, landscape HUD, hit chips, and sound routing.
- `src/studio/build_starter_scene.luau`: editor setup that scales/colors the imported FBX models and builds the tile plot.
- `Assets/Blender/build_asset_library.py`: regenerates the 19 original FBX assets and Blender preview.
- `src/studio/configure_audio_ids.luau`: assigns the Roblox asset IDs after the OGG clips are imported.

## Roblox Studio setup

1. If the named templates are not already in `ServerStorage.TrainMinerAssets`, import the FBX files in `Assets/Blender/fbx` and keep their names unchanged.
2. Run `src/studio/build_starter_scene.luau` in the Studio command bar or through the Roblox Studio MCP. It creates/rebuilds the tile world and stores the scaled templates in `ServerStorage.TrainMinerAssets`.
3. Start `rojo serve default.project.json` and connect the Rojo Studio plugin to synchronize the Luau scripts.
4. Import the OGG clips in `Assets/Audio/Kenney`, copy their resulting asset IDs into `src/studio/configure_audio_ids.luau`, and run that setup script.

`Train-Miner.rbxl` is a Studio snapshot with the first generated tile world and imported models. The scene builder in this repo has the latest cleanup and animated saw mount; rerun it when you next work in Studio to refresh that snapshot. The Luau sources are newer than the scripts in the place, so sync Rojo before pressing Play. Kenney audio clips are in the repo, but their Roblox audio asset IDs still need to be assigned in Studio.
