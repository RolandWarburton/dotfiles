# resize the lf pane to be a sidecar
current_window=$(tmux display-message -p '#I')
pane_index=$(tmux display-message -p '#{pane_index}')
pane_count=$(tmux list-panes -t $current_window -F '#{pane_index}' | wc -l)
window_column_count=$(tmux display-message -p '#{window_width}')

# if there are not multiple panes then we do not want to resize lf
if [ "$pane_count" -eq 1 ]; then
  return 0
fi

if [ "$pane_index" -eq 0 ]; then
  resize_width=$(($window_column_count/5))
  tmux resize-pane -t 0 -x $resize_width
fi
