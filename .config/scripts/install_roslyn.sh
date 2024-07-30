#!/bin/bash

TARGET_DIR="$HOME/.local/share/nvim/roslyn"

if [ -d "$TARGET_DIR" ]; then
    echo "Roslyn Language Server is already installed in $TARGET_DIR"
    exit 0
fi

echo "Copying the .nupkg file to /tmp/roslyn_language_server.nupkg"
NUPKG_FILE="/tmp/roslyn_language_server.nupkg"
cp /mnt/c/Users/rachartier/Downloads/Microsoft.CodeAnalysis.LanguageServer.linux-x64*.nupkg "$NUPKG_FILE"

if [ ! -f "$NUPKG_FILE" ]; then
    echo "Installation failed: $NUPKG_FILE not found."
    exit 1
fi

EXTRACT_DIR="/tmp/roslyn_language_server"
mkdir -p "$EXTRACT_DIR"
echo "Extracting the .nupkg file..."
unzip -o "$NUPKG_FILE" -d "$EXTRACT_DIR"

mkdir -p "$TARGET_DIR"
cp -r "$EXTRACT_DIR/content/LanguageServer/linux-x64/"* "$TARGET_DIR"

DLL_FILE="$TARGET_DIR/Microsoft.CodeAnalysis.LanguageServer.dll"
if [ -f "$DLL_FILE" ]; then
    echo "Roslyn Language Server installed successfully."
    echo "Testing the Roslyn Language Server..."
    VERSION_OUTPUT=$(cd "$TARGET_DIR" && dotnet Microsoft.CodeAnalysis.LanguageServer.dll --version)
    echo "Roslyn Language Server version: $VERSION_OUTPUT"
else
    echo "Installation failed: $DLL_FILE not found."
    exit 1
fi
