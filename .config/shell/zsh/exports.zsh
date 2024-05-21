# Add my home bin to path
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.local/scripts
export XDG_CONFIG_HOME=$HOME/.config

# add custom lua modules if its exists
if command -v luarocks > /dev/null 2>&1 && [ -d "$HOME/.local/luarocks/5.1" ]; then
  eval $(luarocks path)
  export LUA_PATH="$LUA_PATH;$HOME/.local/luarocks/5.1/?/init.lua"
fi

# export default editor
export EDITOR=nvim

# node version manager (NVM)
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# Starship config
export STARSHIP_CONFIG=$HOME/.config/starship.toml

# Go exports
# https://go.dev/doc/install
export GOPATH=$HOME/.local/go/pkg
export PATH=$PATH:/$HOME/.local/go/bin
export PATH=$PATH:/$HOME/.local/go/pkg/bin

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
if [[ -e /usr/lib/dart/bin ]]; then
  export PATH="$PATH:/usr/lib/dart/bin"
fi

# sway options
export SWAYBAR_CONFIG_LOCATION="$HOME/.config/swaybar/config.yml"
