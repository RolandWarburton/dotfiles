ssh_agent_file="$HOME/.ssh-agent"
if [ -e $HOME/.ssh/id_github ] && [ -f "$ssh_agent_file" ]; then
  eval "$(cat "$ssh_agent_file")" 2>&1
  ssh-add ~/.ssh/id_github >/dev/null 2>&1
else
  echo "SSH agent file does not exist!"
fi
