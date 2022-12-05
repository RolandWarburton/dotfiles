#!/usr/bin/env bash

# Run the `tmux show-environment` command and store the output in a variable
output=$(tmux show-environment)

# the <<< operator is used to redirect a string (known as a here string)
# grep quietly (-q) gets a return code and searches for the string in quotes "TMUX_PREFIX=a".
# grep sources its text to grep for by reading from the RHS of <<<
# the <<< operator is used to redirect the contents of the output variable as standard input to
# the grep command.
if grep -q "TMUX_PREFIX=b" <<< "$output"; then
  tmux set-environment TMUX_PREFIX a;
  tmux display-message "Now using A prefix";
  tmux unbind C-b
  tmux set -g prefix C-a
else
  tmux unbind C-a
  tmux set -g prefix C-b
  tmux set-environment TMUX_PREFIX b;
  tmux display-message "Now using B prefix";
fi
