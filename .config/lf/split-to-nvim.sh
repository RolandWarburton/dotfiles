################################################################################
# Opens a file in the previous selected tmux pane
# If the last pane contains an instance of neovim it opens it in a split
# Please note this is experimental and has some issues.
#
# You can also go the other direction (send current working directory from your shell to lf)
#
# lf_select_cwd() {
#   lf -remote "send select $(pwd)" >/dev/null 2>&1
# }
# Bind Ctrl+S to call the function
# bindkey -s '^S' 'lf_select_cwd\n'
################################################################################

if [ ! -f "$HOME/.tmux-pane-id" ]; then
  return 0
 fi
 # get the current window
 current_window=$(tmux display-message -p '#I')
# get the last pane index
last_pane=$(tail -n 2 ~/.tmux-pane-id | head -n 1)
# check that we are not sending the open command to a neovim or lf pane
pane_pid=$(tmux list-panes -t $current_window -F '#{pane_index} #{pane_pid}' | grep "$last_pane " | cut -d ' ' -f2 | head -n 1 )
# try not to open the window in lf
if $(pstree -p "$pane_pid" | grep -qE 'lf\([0-9]+\)'); then
  echo "refusing to open in lf"
  return 0
fi
# open the file path in a vim split
if $(pstree -p "$pane_pid" | grep -qE 'nvim\([0-9]+\)'); then
  echo "opening $fx in a new pane"
  tmux send-keys -t "$last_pane" ":vsp $fx" Enter
  tmux select-pane -t "$last_pane"
  return 0
fi
# open the file in a new instance of vim
git_root=$(git -C "$(dirname "$fx")" rev-parse --show-toplevel 2>/dev/null)
echo $git_root
if [ -n "$git_root" ]; then
  # inside a git repository, we should change the root directory
  tmux send-keys -t "$last_pane" "cd $git_root" C-m
  tmux send-keys -t "$last_pane" "nvim $fx" C-m
  tmux select-pane -t "$last_pane"
else
    # not within a git repository
  tmux send-keys -t "$last_pane" "nvim $fx" C-m
  tmux select-pane -t "$last_pane"
fi
