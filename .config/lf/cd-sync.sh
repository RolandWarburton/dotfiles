################################################################################
# Synchronizes the current lf folder with the last tmux pane
# This is experimental and has some issues
################################################################################

if [ ! -f "$HOME/.tmux-pane-id" ]; then
  echo "no tmux pane history"
  return 0
fi
# get the current window
current_window=$(tmux display-message -p '#I')
# get the last pane index
last_pane=$(tail -n 2 ~/.tmux-pane-id | head -n 1)
if [ -z "$last_pane" ]; then
  echo "last_pane not found"
  return 0
fi
pane_pid=$(tmux list-panes -t $current_window -F '#{pane_index} #{pane_pid}' | grep "$last_pane " | cut -d ' ' -f2 )
if [ -z "$pane_pid" ]; then
  echo "pane_pid not found"
  return 0
fi
# check we are not running anything in this pane
if $(pstree -p "$pane_pid" | grep -qE '^zsh\([0-9]+\)$'); then
  tmux send-keys -t "$last_pane" "cd $PWD" C-m
  return 0
fi
echo "refusing to open in $last_pane"
