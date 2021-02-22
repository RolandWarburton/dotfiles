# This answer looks good but doesnt seem to work for me
# https://unix.stackexchange.com/questions/90853/how-can-i-run-ssh-add-automatically-without-a-password-prompt

# start the ssh agent because it always seems to wanna kill itself
eval `ssh-agent -s` > /dev/null

# Add my nopass key if i have it on this system
if [ -f "$HOME/.ssh/id_nopass_rsa" ]; then
    ssh-add -q  ~/.ssh/id_nopass_rsa
fi

