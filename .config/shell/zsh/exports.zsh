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

# rust toolchain
if [ -d /usr/local/cargo ] || [ -f /usr/bin/cargo ]; then
  # if installed via ansible role (global install)
  export RUSTUP_HOME="$HOME/.rustup"
  export CARGO_HOME="$HOME/.cargo"
  export PATH="/usr/local/cargo/bin:$HOME/.cargo/bin:$PATH"
elif [ -f ~/.cargo/env ]; then
  # local user install (fallback)
  source ~/.cargo/env
fi

# Starship config
export STARSHIP_CONFIG=$HOME/.config/starship.toml

# Golang
[[ -f "/etc/profile.d/golang.sh" ]] && source /etc/profile.d/golang.sh

# Flutter & Dart
# sort -V orders by version, tail -1 picks the highest,
# xargs dirname strips the filename e.g. /opt/flutter/3.44.0/bin/flutter -> /opt/flutter/3.44.0/bin
FLUTTER_DIR=$(find $HOME/.flutter -maxdepth 3 -name flutter -type f 2>/dev/null | sort -V | tail -1 | xargs --no-run-if-empty dirname)
if [[ -n "$FLUTTER_DIR" ]]; then
  export PATH="$PATH:${FLUTTER_DIR}"
  export CHROME_EXECUTABLE=$(which chromium)
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
