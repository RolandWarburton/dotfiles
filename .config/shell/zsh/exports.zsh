# Add my home bin to path
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.local/scripts
export XDG_CONFIG_HOME=$HOME/.config

# add custom lua modules if its exists
# to debug this you can use the luarockspath command (contained in .local/scripts)
export LUA_VERSION=5.1
if command -v luarocks > /dev/null 2>&1 && [ -d "$HOME/.local/luarocks/$LUA_VERSION" ]; then
  eval $(luarocks path)
  export LUA_PATH="$LUA_PATH;$HOME/.local/luarocks/$LUA_VERSION/?/init.lua"
fi

  # . "/home/roland/.deno/env"
[ -s "$HOME/.deno/env" ] && \. "$HOME/.deno/env" # this loads deno

# export default editor
export EDITOR=nvim

# node version manager (NVM)
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# cargo for rust
[ -f ~/.cargo/env ] && source $HOME/.cargo/env

# Starship config
export STARSHIP_CONFIG=$HOME/.config/starship.toml

# Golang
[[ -f "/etc/profile.d/golang.sh" ]] && source /etc/profile.d/golang.sh

# Flutter & Dart
# Install from https://dart.dev/get-dart
if [[ -e /usr/lib/dart/bin ]]; then
  export PATH="$PATH:/opt/flutter/bin:/usr/lib/dart/bin"
  export CHROME_EXECUTABLE=`which chromium`
fi

# sway options
export SWAYBAR_CONFIG_LOCATION="$HOME/.config/swaybar/config.yml"

# Add .local/fpath to fpath
# Define the path to the directory
local_fpath="$HOME/.local/zshfn"

# Check if the directory exists
if [ ! -d "$local_fpath" ]; then
  # If the directory doesn't exist, create it
  mkdir -p "$local_fpath"
fi

# Add the directory to fpath if it's not already there
if [[ ":$fpath:" != *":$local_fpath:"* ]]; then
  fpath+=("$local_fpath")
fi
