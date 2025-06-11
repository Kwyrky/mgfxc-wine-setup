# mgfxc-wine-setup
This script is used to setup the needed Wine environment so that mgfxc can be run on Linux / macOS systems.

It installs / extracts
.NET SDK 3.1 for MonoGame 3.8.0
.NET SDK 6.0 for MonoGame 3.8.1
.NET SDK 8.0 for MonoGame 3.8.4
and d3dcompiler_47.dll
to
~/.<WINE_MONOGAME_PREFIX>/drive_c/windows/system32/
e.g.
~/.winemonogame/drive_c/windows/system32/

If you want to you can change WINE_MONOGAME_PREFIX.
This will be the name of the wine prefix created in the 
home directory and used by MonoGame.

Before running the script make sure you have all dependencies installed:
```bash
$ sudo apt install wget curl p7zip-full wine64 
```

After running the script run this command to enable effect compilation immediately without the need to logout and login or reboot:
```bash
$ source ~/.profile
```