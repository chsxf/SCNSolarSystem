# ❓ About This Project

SCNSolarSystem is an educational project for developers learning how to use [Apple's SceneKit 3D framework](https://developer.apple.com/scenekit/).

This is an inaccurate representation of our solar system, originally made for my kids.

## Conventions

This project uses [gitmoji](https://gitmoji.dev) for its commit messages.

# 🖥 Supported Platforms

SceneKit being a proprietary framework from Apple, the game will only be avaiable on the following Apple platforms:

- macOS 10.15+
- iOS / iPadOS 15+

## iOS / iPadOS

As an educational project, SCNSolarSystem is not available directly from the App Store.
If you want to play on your iPhone or iPad, please clone this repository, open the project directly in Xcode and run the game directly on your device.

# 🎮 Controls

## Keyboard

| Key              | Command                                 |
| ---------------- | --------------------------------------- |
| Space            | Enable thrust                           |
| Up/Down Arrow    | Move the rocket up or down              |
| Left/Right Arrow | Rotate the rocket towards left or right |

## Game Controller

The game uses the Game Controller framework, so only [natively supported controllers](https://support.apple.com/en-us/HT210414) will work.
On iOS, if no compatible controller is found, a virtual controller is provided as an alternative.

| Key                                                                                                               | Command                                                              |
| ----------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| A / ![ps-x](https://user-images.githubusercontent.com/3322862/118397164-fa6db780-b652-11eb-967c-9e6fd7a51703.png) | Enable thrust                                                        |
| Left Stick                                                                                                        | Move the rocket up or down, rotate the rockets towards left or right |

# ⚖️ License

To the exception of those mentioned below, all source code and assets are distributed under the [MIT License](LICENSE).

## Solar System Textures

Available on the [Solar System Scope](https://www.solarsystemscope.com/textures/) and distributed under the [Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/) license.

## Rocket Model

Distributed under the [Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/) license by [Alexander_Studenkov](https://sketchfab.com/Alexander_Studenkov) on [Sketchfab](https://sketchfab.com/3d-models/toy-rocket-42ef8d4b882c4c94947479b427098498). The pedestal has been removed and materials have been migrated to the Blinn lighting model.
