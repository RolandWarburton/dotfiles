# The purpose of this is to try and have just one ssh-agent running at a time
# when called it will check eval it the existing agent, then add my github key.
#
# when developing you can find unnecessary processes using `ps -ef | grep ssh-agent `
#
# IMPORTANT
# The ssh-agent will need to be instantiated somewhere else. I suggest in your WM/DE init script (sway, xfce, etc)

add_keys() {
  # Define an array of SSH key paths
  # multiple keys can be specified between the brackets with a space
  # (key1 key2 key3)
  local keys=(~/.ssh/id_github)
  for key in "${keys[@]}"; do
    if [ -f "$key" ]; then
      ssh-add "$key" >/dev/null 2>&1
    fi
  done
}

ssh_agent_file="$HOME/.ssh-agent"
if [ -f $HOME/.ssh/id_github ] && [ -f "$ssh_agent_file" ]; then
  eval "$(cat "$ssh_agent_file")" > /dev/null 2>&1
  add_keys
else
  echo "Writing SSH agent information to $HOME/.ssh-agent"
  ssh-agent > $HOME/.ssh-agent
  eval "$(cat "$ssh_agent_file")" 2>&1
  add_keys
fi
