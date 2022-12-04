# Refer to /usr/lib/systemd/user/ssh-agent.service
# which creates this socket

# check if the ssh-agent.socket file exists in the user runtime directory
if [[ -e "$XDG_RUNTIME_DIR/ssh-agent.socket" ]]; then
  export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
fi

