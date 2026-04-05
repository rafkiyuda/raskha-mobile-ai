#!/bin/bash

# Vercel Flutter Web Installation Script
# This script downloads and installs the Flutter SDK in a Linux x64 environment.

set -e

FLUTTER_VERSION="3.35.7"
INSTALL_DIR="$HOME/development"

if [ ! -d "$INSTALL_DIR" ]; then
  mkdir -p "$INSTALL_DIR"
fi

cd "$INSTALL_DIR"

if [ ! -d "flutter" ]; then
  echo "Downloading Flutter SDK v$FLUTTER_VERSION..."
  curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_$FLUTTER_VERSION-stable.tar.xz
  echo "Extracting Flutter SDK..."
  tar xf flutter_linux_$FLUTTER_VERSION-stable.tar.xz
  rm flutter_linux_$FLUTTER_VERSION-stable.tar.xz
  echo "Flutter SDK installed successfully."
fi

# Add Flutter to PATH for the current session
export PATH="$PATH:$INSTALL_DIR/flutter/bin"

# Pre-download dependencies
flutter precache --web
flutter doctor
