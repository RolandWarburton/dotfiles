![heading](https://github.com/RolandWarburton/dotfiles/raw/master/Media/heading.png  "heading")

# Rolands Dotfiles

## Installing

```none
# config
export USERNAME=roland

# as root
apt update
apt install git vim curl sudo
localedef -i en_US -f UTF-8 en_US.UTF-8
usermod -aG sudo $USERNAME
reboot now

# as user
mkdir $HOME/.ssh
scp $USER@desktop:$HOME/.ssh/id_rsa $HOME/.ssh
scp $USER@desktop:$HOME/.ssh/id_rsa.pub $HOME/.ssh
chmod 600 $HOME/.ssh/id_rsa
chmod 644 $HOME/.ssh/id_rsa.pub
ssh-add ~/.ssh/id_rsa
git clone git@github.com:rolandwarburton/dotfiles.git
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source $HOME/.bashrc
nvm install --lts

# as user
cd dotfiles
npm run install
npm run build
node bin/index.js
```

## Re-syncing dotfiles

Refresh the existing dotbot managed configs with the dotbot command.

```none
dotbot -c ./install.conf.yaml
```

If you wish to re-run the original install_dots script you can, but it **may** not be as idempotent as dotbot is.

## Resources

1. [Linux Notes](https://blog.rolandw.dev/notes/linux/)
2. [ZSH tidbits](http://zzapper.co.uk/zshtips.html)

## TODO List

* [x] Develop my site to make my linux notes more modular and searchable ([here!](https://blog.rolandw.dev/notes/linux))
* [x] Develop a shell script that installs these dot files ([dotbot](https://github.com/anishathalye/dotbot))
* [x] Create an "auto installer" for firefox that downloads it and places it in the right location etc
* [ ] Modify zshrc to only run the bits for loading in nvm IF nvm actually exists
