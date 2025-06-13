# mgfxc-wine-setup

> ⚠️ **Disclaimer:** This script was tested on my personal system (Linux Mint 22 "Wilma" – based on Ubuntu 24.04 LTS "Noble Numbat"), but it comes with **no guarantees**. It may or may not work on your setup, and I can't ensure compatibility or correctness on any particular system.

## Info
This script is used to setup the needed Wine environment so that mgfxc can be run on Linux / macOS systems.

It installs / extracts
* `.NET SDK 3.1` for `MonoGame 3.8.0`
* `.NET SDK 6.0` for `MonoGame 3.8.1`
* `.NET SDK 8.0` for `MonoGame 3.8.4`
* and `d3dcompiler_47.dll`
to
`~/.<WINE_MONOGAME_PREFIX>/drive_c/windows/system32/`
e.g.
`~/.winemonogame/drive_c/windows/system32/`

The `WINE_MONOGAME_PREFIX` variable in the script defines the name of the Wine prefix folder, which will be created in your home directory with a leading dot (`~/.<WINE_MONOGAME_PREFIX>` e.g. `~/.winemonogame`) to make it a hidden folder.

Before running the script make sure you have all dependencies installed:
```bash
$ sudo apt install wget curl p7zip-full wine64 
```

Run the script which should create a folder `~/.<WINE_MONOGAME_PREFIX>` e.g. `~/.winemonogame`:
```bash
$ ./mgfxc-wine-setup.sh
```

After running the script run this command to enable effect compilation immediately without the need to logout and login or reboot:
```bash
$ source ~/.profile
```

## Undo
To undo the script at any time simply delete the created folder and delete `export MGFXC_WINE_PATH="/home/<USER>/.<WINE_MONOGAME_PREFIX>"` from `~/.profile` or `~/.zprofile`. 
If it exists delete also `export PATH="$PATH:/home/<USER>/.<WINE_MONOGAME_PREFIX>"`.

