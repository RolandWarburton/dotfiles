# Add my home bin to path
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.local/scripts
export XDG_CONFIG_HOME=$HOME/.config

# Go exports
export GOPATH=$HOME/.local/go/pkg
export PATH=$PATH:/$GOPATH/bin

# Android Studio
export ANDROID_HOME=/home/roland/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Flutter
export PATH="$PATH:/opt/flutter/bin"
export CHROME_EXECUTABLE=`which chromium`

# Dart
# Install from https://dart.dev/get-dart
export PATH="$PATH:/usr/lib/dart/bin"

# vivi
export ADB_VENDOR_KEYS="$HOME/.ssh/adb" # chmod 600 this

