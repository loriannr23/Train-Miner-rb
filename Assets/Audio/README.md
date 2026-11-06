# Kenney audio set

These eight OGG clips are staged for the first Train Miner prototype. They come from Kenney's **Interface Sounds** and **Impact Sounds** packs. Both included license files state CC0; attribution is optional.

| File | In-game use |
| --- | --- |
| `UI_Click.ogg` | Camera and small menu actions |
| `UI_Open.ogg` | Open/build actions |
| `UI_Confirm.ogg` | Successful roll, merge, sale, or build |
| `UI_Error.ogg` | Insufficient coins/materials or locked content |
| `Resource_WoodHit.ogg` | Saw hits a tree |
| `Resource_WoodBreak.ogg` | Tree reaches its final stump stage |
| `Resource_StoneHit.ogg` | Saw hits or breaks stone |
| `Resource_CrystalHit.ogg` | Saw hits or breaks crystal |

Roblox needs an uploaded audio asset ID before its game client can stream a local OGG file. The code creates matching `Sound` objects under `SoundService.TrainMinerSounds`; their `SoundId` fields stay empty until the imported IDs are added to `src/studio/configure_audio_ids.luau` and that setup script is run in Studio.

Pack pages: [Interface Sounds](https://kenney.nl/assets/interface-sounds) · [Impact Sounds](https://kenney.nl/assets/impact-sounds).
