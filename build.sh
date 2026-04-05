#!/bin/bash

# Vercel Flutter Web Build Script
# This script runs the Flutter web-specific build command.

set -e

# Add Flutter to PATH in case it was installed in $HOME/development/flutter
# as done by the install-flutter.sh script.
export PATH="$PATH:$HOME/development/flutter/bin"

# Navigate to the project root (context from Vercel)
cd "${0%/*}"

echo "Fetching Flutter dependencies..."
flutter pub get

echo "Building Flutter Web application (Release)..."
flutter build web --release

echo "Build complete. Output is in build/web/"
