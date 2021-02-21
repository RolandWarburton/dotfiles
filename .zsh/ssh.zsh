# https://unix.stackexchange.com/questions/90853/how-can-i-run-ssh-add-automatically-without-a-password-prompt
if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent -s`

    # Add my key with no password
    [ -f ~/.ssh/id_nopass_rsa ] && ssh-add ~/.ssh/id_nopass_rsa

    # uncomment this to add ~/.ssh/id_rsa to the agent.
    # If its password protected then it WILL prompt you for the password
    # ssh-add
fi
