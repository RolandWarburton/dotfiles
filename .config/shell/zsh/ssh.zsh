# The purpose of this is to try and have just one ssh-agent running at a time
# when called it will check eval it the existing agent, then add my github key.
#
# when developing you can find unnecessary processes using `ps -ef | grep ssh-agent `
#
# IMPORTANT
# The ssh-agent will need to be instantiated somewhere else. I suggest in your WM/DE init script (sway, xfce, etc)

ssh_agent_file="$HOME/.ssh-agent"
if [ -f $HOME/.ssh/id_github ] && [ -f "$ssh_agent_file" ]; then
  eval "$(cat "$ssh_agent_file")" 2>&1
  ssh-add ~/.ssh/id_github >/dev/null 2>&1
else
  echo "SSH agent file does not exist!"
fi
