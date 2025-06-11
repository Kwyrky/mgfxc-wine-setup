#!/bin/bash
# This script is used to setup the needed Wine environment
# so that mgfxc can be run on Linux / macOS systems.

# It installs / extracts
# .NET SDK 3.1 for MonoGame 3.8.0
# .NET SDK 6.0 for MonoGame 3.8.1
# .NET SDK 8.0 for MonoGame 3.8.2
# and d3dcompiler_47.dll
# to
# ~/.winemonogame/drive_c/windows/system32/

# If you need to you can change WINE_MONOGAME_PREFIX.
# This will be the name of the wine prefix used by
# MonoGame.

# Define the Wine prefix directory
WINE_MONOGAME_PREFIX="winemonogame"
WINE_MONOGAME_DIR="$HOME/.$WINE_MONOGAME_PREFIX"

# check dependencies
if ! type "wine64" > /dev/null 2>&1
then
    echo "wine64 not found"
    exit 1
fi

if ! type "7z" > /dev/null 2>&1
then
    echo "7z not found"
    exit 1
fi

# wine 8 is the minimum requirement for dotnet 8
# wine --version will output "wine-#.# (Distro #.#.#)" or "wine-#.#"
WINE_VERSION=$(wine --version 2>&1 | grep -oP 'wine-\d+' | sed 's/wine-//')
if (( $WINE_VERSION < 8 )); then
    echo "Wine version $WINE_VERSION is below the minimum required version (8.0)."
    exit 1
fi

# init wine stuff
export WINEARCH=win64
export WINEPREFIX="$WINE_MONOGAME_DIR"
wine64 wineboot

TEMP_DIR="${TMPDIR:-/tmp}"
SCRIPT_DIR="$TEMP_DIR/$WINE_MONOGAME_PREFIX"
mkdir -p "$SCRIPT_DIR"

# disable wine crash dialog
cat > "$SCRIPT_DIR/crashdialog.reg" <<_EOF_
REGEDIT4
[HKEY_CURRENT_USER\\Software\\Wine\\WineDbg]
"ShowCrashDialog"=dword:00000000
_EOF_

pushd "$SCRIPT_DIR"
wine64 regedit crashdialog.reg
popd

DOTNET_URL_3_1="https://download.visualstudio.microsoft.com/download/pr/adeab8b1-1c44-41b2-b12a-156442f307e9/65ebf805366410c63edeb06e53959383/dotnet-sdk-3.1.201-win-x64.zip"
DOTNET_URL_6_0="https://download.visualstudio.microsoft.com/download/pr/e71628cc-8b6c-498f-ae7a-c0dc60019696/aaadc51ad300f1aa58250427e5373527/dotnet-sdk-6.0.202-win-x86.zip"
DOTNET_URL_8_0="https://dotnetcli.azureedge.net/dotnet/Sdk/8.0.201/dotnet-sdk-8.0.201-win-x64.zip"

DOTNET_FILE_3_1=$(basename "$DOTNET_URL_3_1")
DOTNET_FILE_6_0=$(basename "$DOTNET_URL_6_0")
DOTNET_FILE_8_0=$(basename "$DOTNET_URL_8_0")

OUTPUT_DIR="$SCRIPT_DIR"

# Download and extract .NET SDK 3.1
[[ -e "$OUTPUT_DIR/$DOTNET_FILE_3_1" ]]                  || curl "$DOTNET_URL_3_1" --output "$OUTPUT_DIR/$DOTNET_FILE_3_1"
[[ -d "$WINEPREFIX/drive_c/windows/system32/3.1.201/" ]] || 7z x "$OUTPUT_DIR/$DOTNET_FILE_3_1" -o"$WINEPREFIX/drive_c/windows/system32/" -aoa

# Download and extract .NET SDK 6.0
[[ -e "$OUTPUT_DIR/$DOTNET_FILE_6_0" ]]                  || curl "$DOTNET_URL_6_0" --output "$OUTPUT_DIR/$DOTNET_FILE_6_0"
[[ -d "$WINEPREFIX/drive_c/windows/system32/6.0.202/" ]] || 7z x "$OUTPUT_DIR/$DOTNET_FILE_6_0" -o"$WINEPREFIX/drive_c/windows/system32/" -aoa

# Download and extract .NET SDK 8.0
[[ -e "$OUTPUT_DIR/$DOTNET_FILE_8_0" ]]                  || curl "$DOTNET_URL_8_0" --output "$OUTPUT_DIR/$DOTNET_FILE_8_0"
[[ -d "$WINEPREFIX/drive_c/windows/system32/8.0.201/" ]] || 7z x "$OUTPUT_DIR/$DOTNET_FILE_8_0" -o"$WINEPREFIX/drive_c/windows/system32/" -aoa

# Download and extract d3dcompiler_47.dll
FIREFOX_URL="https://download-installer.cdn.mozilla.net/pub/firefox/releases/62.0.3/win64/ach/Firefox%20Setup%2062.0.3.exe"
FIREFOX_FILE=$(basename "$FIREFOX_URL")
[[ -e "$OUTPUT_DIR/$FIREFOX_FILE" ]]                               || curl "$FIREFOX_URL" --output "$OUTPUT_DIR/$FIREFOX_FILE"
[[ -f "$WINEPREFIX/drive_c/windows/system32/d3dcompiler_47.dll" ]] && sha256sum $WINE_MONOGAME_DIR/drive_c/windows/system32/d3dcompiler_47.dll
[[ -f "$WINEPREFIX/drive_c/windows/system32/d3dcompiler_47.dll" ]] && 7z e "$OUTPUT_DIR/$FIREFOX_FILE" "core/d3dcompiler_47.dll" -o"$WINEPREFIX/drive_c/windows/system32/" -aoa

# append MGFXC_WINE_PATH env variable
echo -e "\nexport MGFXC_WINE_PATH=$WINE_MONOGAME_DIR" >> ~/.profile
echo -e "\nexport MGFXC_WINE_PATH=$WINE_MONOGAME_DIR" >> ~/.zprofile

# cleanup
rm -rf "$SCRIPT_DIR"

# info
ls -alF $WINE_MONOGAME_DIR/drive_c/windows/system32/sdk
ls -alF $WINE_MONOGAME_DIR/drive_c/windows/system32/d3dcompiler_47.dll
[[ -f "$WINEPREFIX/drive_c/windows/system32/d3dcompiler_47.dll" ]] && sha256sum $WINE_MONOGAME_DIR/drive_c/windows/system32/d3dcompiler_47.dll
