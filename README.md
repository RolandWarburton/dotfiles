![heading](https://github.com/RolandWarburton/dotfiles/raw/master/Media/heading.png  "heading")

# Rolands Dotfiles

## Installing

```none
sudo apt install python3 python3-pip python3-venv
source venv/bin/activate
pip3 install dotbot
```

Then run the installer. This will install packages from debian, run dotbot for the user dotfiles, and prompt you to install missing optional software.

```none
./install_dots.sh
```

Then run dotbot as the root user to link etc files.

```none
su -
cd /home/roland/dotfiles
source venv/bin/activate
dotbot -c install.sudo.conf.yaml
```

Changes will not take full effect until you reboot, use `sudo reboot`.

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
* [x] Create an "auto installer" for firefox that downloads it and places it in the right location etc
* [ ] Modify zshrc to only run the bits for loading in nvm IF nvm actually exists
