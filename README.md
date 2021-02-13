![heading](https://github.com/RolandWarburton/dotfiles/raw/master/Media/heading.png  "heading")

# Rolands Dotfiles

## Installing

Set your path for python to read dotbot from and install dotbot (requires python3 and python3-pip).

```none
export PATH=$PATH:$HOME/.local/bin
pip3 install dotbot
```

Then set your locale information accordingly, make sure you are root for this as it doesn't seem to work with sudo.

```none
su -
echo "LC_ALL=en_US.UTF-8" >> /etc/environment
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
locale-gen en_US.UTF-8
```

Then run the installer.

```none
./install_dots.sh
```

Changes will not take full effect until you reboot.

```none
sudo reboot
```

After rebooting your shell should be changed to zsh. Install zsh plugins now with.

```none
zplug load
zplug install
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
* [ ] Create an "auto installer" for firefox that downloads it and places it in the right location etc
* [ ] Modify zshrc to only run the bits for loading in nvm IF nvm actually exists
