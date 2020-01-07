# Rolands List of things that ive learnt about linux
I aim to keep this list up to date with all the small gottchas and references to things ive picked up over time while working with linux.

Topics that go off on a tangent that are '*good to know but not related to linux specifically*' are located at the bottom of the document under [non related linux things](https://gist.github.com/RolandWarburton/33a44ba246da577cee2f16da502d7464#non-related-linux-things).

My Current configuration:\
OS: Arch Linux\
DE: openbox\
Shell: zsh\
Terminal: kitty\
Dots: [Dots!](https://github.com/RolandWarburton/dotfiles)

# MIME
### What is MIME
Handles default programs for filetypes (text/plain, text/x-c++, etc).
Theres a neato app that lets you graphically look at your 'default files' - [xfce4-mime-settings](https://www.archlinux.org/packages/extra/x86_64/xfce4-settings/) (part of the xfce4 settings app)app.
the arch page for this is [here](https://wiki.archlinux.org/index.php/default_applications)

The MIME config is usually in ```.config/mimeapps.list``` (older systems sometimes calls it defaults.list)

### Setting a default application
Example for setting a default file manager:
```xdg-mime default thunar.desktop inode/directory```\
Where inode/directory is the MIME type.

### What is XDG in relation to MIME
[xdg-utils](https://wiki.archlinux.org/index.php/Xdg-utils#xdg-open) is a set of tools that allows applications to easily integrate with the desktop environment of the user, regardless of the specific desktop environment that the user runs.
XDG uses MIME database to open files. ```xdg-open <filename.xyz>``` will open a file.
You can even do ```xdg-open .``` and it will open a file explorer at that location in the terminal.

XDG is part of LSB (linux standard base) which aims to make developing different distributions easier.

### Useful MIME types
Here are some good examples of MIME types that i have set up on my own system.
A list of types can also be found at this [website](https://www.freeformatter.com/mime-types-list.html).
```
[Default Applications]
inode/directory=thunar.desktop;
application/x-bittorrent=uget-gtk.desktop;
x-scheme-handler/magnet=uget-gtk.desktop
```

### Find the "name" of an application
All applications are stored in ```/usr/share/applications/*```.

# PIP and Python
### Environments
"aughhhh pip is a mess! I dont want pip packages installed globally!!!"\
Create an environment for pip stuff in a folder (works with python3 only)
1. Create an environment ```python -m venv pythonEnvironment```
2. Switch source ```source pythonEnvironment/bin/activate```. 'source is a built in shell command, it runs the content that the venv command generated to change the source of python'
3. verify that you switched environments ```which python``` => ```some/files/pythonEnvironment/bin/python```
4. to exit the venv. ```deactivate``` (another bash command)

### PIP packages are not recognised.
Install the python extension to python and use the bottom left menu titled 'python 3.x.x 64 bit' and click on it to change the environment.

### Cant import package thats nested in a folder.\
use the syntax ```import foldername.somefile```.

### ```pip list``` Vs ```pip freeze```
without installing any extra packages there are 43 packages in pip list and 39 packages in pip freeze.
* pip list is longer because it has the package *setuptools* and *pip* itself.
* Pip freeze is used to generate the *requirements.txt* file for automatically installing a list of packages.

# Mounting internal drives with the CLI
### Mount EXT file systems
1. Check for the drive ```lsblk```
2. Mount the drive in the users folder (create/use the 'media' folder)\
```sudo mount /dev/sdb2 /home/roland/mount```
3. Give the user permission
```sudo chown roland /home/roland/mount```

Unmount with ```sudo umount /home/roland/Media```.

### Mount NTFS (Windows) drives
install the [ntfs-3g](https://wiki.archlinux.org/index.php/NTFS-3G) package.\
Mount the NTFS drive with ```sudo sudo ntfs-3g /dev/sdb2 /home/roland/mount```.\
Unmount the drive the same way you would with any filesystem ```sudo umount /home/roland/Media```.

### Automatic mouting
You can install [thunar-volman](https://www.archlinux.org/packages/extra/x86_64/thunar-volman/) to automatically mount a volume when its plugged in.
*I am yet to find a solution that works well for mounting internal hard drives That are NTFS (Windows). 
Though theres a way to add EXT3 and EXT4 volumes (linux) using [udisks2](https://wiki.archlinux.org/index.php/Udisks).*

# Ricing linux
### Display a cool banner when logging in with SSH
Modify */etc/issue.net* and write a cool message in there. then make sure banners are enabled.
``` 
#/etc/ssh/sshd_config 
Banner /etc/issue.net
```

### Display a cool login message when logging in with SSH
Switch user to root and modify the bash scripts in ```/etc/update-motd.d/```. The number of the file indicate the order in which they are executed.

### Moving config files to nicer locations
#### Zsh stuff to ~/.config/zsh
Configure the global variable $ZDOTDIR to change where zsh looks for its config files.
```
/etc/zsh/zshenv
export ZDOTDIR=$HOME/.config/zsh
```

### .xinitrc, .xsession, and .xresources
#### .xinitrc
Runs when you run the startx command. This should be autorun when you log in to start your DE or WM by adding a line to zshrc or bashrc to call it as soon as the shell starts.
```
# autostart xinit (startx) on your shell (same on zsh and bash etc)
if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi
```

#### startx vs xinit
xinit is a more bare bones version of startx. xinit only starts the X server and runs anything in the users xinitrc. you will get a black screen and no DE or WM if nothing is specified in your xinitrc.

startx starts the X server and looks for additional files. Have a look at ```which startx``` to see the  startx script.

#### .xsession
xsession is used by graphical login managers like sddm and gdm and is seperate from xinitrc. (xinitrc is used by startx, xorg and init when starting an actual DE or WM).
Though xsession can be used as a fallback if no .xinitrc is found.

Runs when a graphical environment starts. Its purpose is to contain user configuration and may contain
* Environment variables. ```export VARIABLE=thing```
* Calling other scripts to run ```if [ -r ~/.runascript ]; then . ~/.runascript; fi```
* starting programs ```chromium```

Though it is considered *advanced* (and therefore had no great documentation), xsession may also start your DE or WM like how you would run it in xinitrc. This avoids the need for a .xinitrc and using the *startx* command which is deprecated on some distros (openSUSE).
```
# .xsession
exec dbus-launch openbox-session
```

#### .xresources
Has to be called by *.xinitrc* or *.xsession* to run. It is part of the xorg-xrdg package and configures parameters (usually appearance) for X client applications (like xterm and xclock etc).
xinitrc by default merges (combines the xresources with current config so you dont have to type all the things you dont want to change again). You can also technically load xresources from *.xsession*. 

The default settings that .xresources merges with or overrides are at ```/usr/share/X11/app-defaults/```

Command to merge xresources for either .xinitrc (prefered) or .xsession: ```[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources```

You can also check currently loaded resources to confirm if anything was loaded with ```xrdb -query -all```   

### Making thunar dark theme
Thunar is a GTK (gimp toolkit) app. This is a generic library used for graphics interfaces.
Gtk can be themed, and therefore will incluence all the GTK widgets that make up these applications.
You can configure thunar and the system wide theme with lxappearance.\
lxappearance is part of Xappearance: *XAppearance — Desktop independent GTK 2 and GTK 3 style configuration tool from the LXDE project (it does not require other parts of the LXDE desktop).*
1. install lxappearance
2. run and select a theme!

### Install an icon theme
The best way i found to do this is through lxappearance.\
Icons should be in the ```/usr/share/icons``` folder for all users, or the ```~/icons/``` folder for local users. Avoid putting icon themes in the home directory.
1. Install an icon theme through the repos or AUR
2. use the icon-theme tab on lxappearance to select that theme, it should appear there automatically

# Man pages
### Navigating Man pages
Use your vim keys harry!
* ctrl+f = / [word to search for]
* go to next found word = n
* go to prev found word = shift+n

# Grep and regex
**Problem:** Regex expression not acting correctly compared to other online regex tools.\
**Solution:** put your regex in quotes.
```
# WRONG
cat a.txt | grep -E word.*
# CORRECT
cat a.txt | grep -E 'word.*'
```

**Problem:** no colors on matched regex.\
**Solution:** use the ```--color``` tag. Perhaps make an alias for it in zsh to use it automatically.
```
#~/.zshrc
alias grep="grep --color"
```

# Navigation tips
This is a broad topic on some neat tricks in navigating around linux.

### Use ranger to visually navigate a shell
* Install ranger. perhaps create an alias for example 'r' to open ranger quicker.
* Navigate to the folder you want. Press *S* (Shift+s) to cd to that location.
* Type *exit* to go back into ranger. 

# Image manipulation
### Converting from gif to to image series
```convert target.gif -coalesce Frames/output_%02d.png```\
-coalesce means *merge a sequence of images*

### Converting from image series to a gif
```convert -delay 20 fullBody_*.png -loop 0 fullBody.gif```.

# Debian and apt based systems
### downloading a package from a source (16.04 xenial only).
browse the website [launchpad](https://launchpad.net). For example [https://launchpad.net/ubuntu/+source/kitty](https://launchpad.net/ubuntu/+source/kitty).\
Once you find a package go to your debian system and type ```sudo apt-add-repository ppa:kitty/ppa```.\
Then sync your packages ```sudo apt-get update```. Then install it with ```sudo apt-get install kitty```.

In the event that you get the error: *The repository 'http://ppa.launchpad.net/kitty/ppa/ubuntu bionic Release' does not have a Release file.*\
This means the package is not built for that version of debian/ubuntu. Look for alternate versions under *Other versions of 'somepackage' in untrusted archives.*.

To remove the ppa use ```sudo add-apt-repository --remove ppa:mc3man/trusty-media``` then ```sudo apt-get update```.

### Remove a package entirely
Purge ```sudo apt-get purge packageName*```\
Remove logs (if any) ```sudo rm -r /var/log/packageName```\
Remove other files (if any) ```sudo rm -r /var/lib/packageName```

### Upgrade and update packages
Update = get new versions of packages. Dont install them.\
Upgrade = Install any new updated packages.\
run update first then upgrade.\
```sudo apt update``` then ```sudo apt upgrade```.

### Upgrade the entire distribution
Install the new release for the upgrade ```sudo apt-get dist-upgrade```\
Run the update ```sudo do-release-upgrade```

### Maintaining APT packages
#### HIT, IGN, and GET meaning
When you run ```sudo apt update```. What do these things mean?
**Hit** = Package didnt change since the last check. there is no newer version of the package.\
**Get** = This means there is a package update(new version) available and it will download the details for this update, but not the update itself.\
**Ign** = This means that the package has been ignored. This happens either because of an error or because the package is recent and there is no need to check it for updates.

### Third party stuff:
Every third party package has a key (called an APT or GPT key). review the list of keys with ```sudo apt-key list```\
The last 8 digits is the key ID (058F 8B6B)
```
/etc/apt/trusted.gpg
--------------------
pub   rsa4096 2018-04-18 [SC] [expires: 2023-04-17]
      E162 F504 A20C DF15 827F  718D 4B7C 549A 058F 8B6B
uid           [ unknown] MongoDB 4.2 Release Signing Key <packaging@mongodb.com>
```
Remove this key with ```sudo apt-key del 058F8B6B```

All of your third party sources should be in ```/etc/apt/sources.list.d/*``` with seperate files for each source.\
All of your ubuntu packages and packages from the ubuntu repos should go in ```/etc/apt/sources.list```

#### Process of installing a third party package:
1. import the key with ```sudo apt-key add``` from some script.\
Example: ```wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -```
2. Create a source file in ```/etc/apt/sources.list.d/```\
Example: ```echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list```. The use of the 'tee' command means that the command is redirected into stdout and a file. Ie. echo it and put it in the file.

#### see big list of all sources installed. (not sure what it is tho or what it means, or what its important for haha)
```ls /var/lib/apt/lists```
If you delete this folder and run ```apt get update``` again it redownloads all of the files again.

### Snap Packages
Snap is an alternative way to package software. It was developed by canonical (who are the creators of ubuntu) and as such is on ubuntu/ubuntu server and ubuntu derivitives, snap can also be installed on other non ubuntu related distributions such as debian or arch (aur) where it is not installed by default by installing the *snapd* package.

You can check what snap packages are currently installed with ```snap list```.
Example Output:
```
Name  Version    Rev   Tracking  Publisher   Notes
code  26076a4d   23    stable    vscode✓     classic
core  16-2.42.5  8268  stable    canonical✓  core
```

You can search for information about a package, such as its channels (releases, eg stable/latest/beta etc)

#### Managing/Updating snap packages
You can check the last time a refresh (update) was run with ```snap refresh --time```. and look at what changes were made with ```snap changes```

By defaut Snap packages check for updates 4 times a day and will update themselves. You can change this by running 
```sudo snap set system refresh.timer=4:00-7:00,19:00-22:10 ``` and defining your own times. 

Manually updating a snap package: ```snap refresh myPackage``` or check for updates on all packages with ```snap refresh```.


# X11 Forwarding
X11 Forwarding allows you to launch **applications** from remote linux systems on your system. Think screenshare but for a single application (It is possible to share an entire DE but i have never attempted it).
```
+--------+>--------file.txt------->+--------+
| SERVER |                         | CLIENT |
+--------+<-------ssh-server------<+-+----+-+
└── file.txt                         ^    |
                                     |    |
                                     |    v
                             +-------+----+------+
                             | File.Txt          |
                             |                   |
                             | text text text    |
                             | text text text    |
                             | text text text    |
                             |                   |
                             |                   |
                             |                   |
                             |                   |
                             +-------------------+
```
1. install *xauth* and optionally *xclock* for testing.
2. set $DISPLAY variable to ```localhost:displaynumber.screennumber```. Example: ```export DISPLAY=localhost:10.0```.
3. edit ```/etc/ssh/sshd_config``` and ```/etc/ssh/ssh_config```.
```
# /etc/ssh/sshd_config

# Either...
# Globally
X11Forwarding yes
X11DisplayOffset 10 <- this is the display number used in step 2.

#Per user/group
Match user roland
X11Forwarding yes
X11DisplayOffset 10
```
```
#/etc/ssh/ssh_config

Host *
   ForwardX11 yes
   ForwardX11Trusted yes
```
Connect to the server with the -X tag (-X is not needed if you set up sshd_config X11Forwarding) ```ssh -p 22 -X roland@server```
* Observe xauth to see that a key was created for forwarding ```xauth list $DISPLAY```. You may need to add this key with ```xauth add localhost.displaynumber:10 MIT-MAGIC-COOKIE-1 4d22408a71a55b41ccd1657d377923ae```

### Optimising X11 Forwarding
By default X11 Forwarding is pretty slow.
* Use the -Y tag to indicate you trust the machine instead of the -X tag. This will bypass security checks and might make the connection faster.
* use the -C tag to compress the connection. 
* prevent timeout by editing ```~/.ssh/config``` and adding ```ForwardX11Timeout 1d``` (1 day).

# Terminal stuff
### Terminal key codes
Its useful to know the keycodes when you are mapping buttons to do things.

```showkey -a```
Example:
```
a 	97 0141 0x61
b 	98 0142 0x62
c 	99 0143 0x63
1 	49 0061 0x31
2 	50 0062 0x32
3 	51 0063 0x33
```

### Locations of useful things
##### TermInfo files: 
```ls /usr/share/terminfo/x```\
List of supported terminals. use ```echo $TERM``` to what terminal the system thinks its using.\
You can export a new $TERM from the list above.

##### All user accounts:
```ls /etc/psswd```

##### node modules: ```/usr/local/lib/node_modules```

# SSH/FTP/SFTP stuff
### Prevent timeout
Use client AND server side configuration.\
**Client:** ```echo "ServerAliveInterval 60" > ~/.ssh/config```.\
**Server:** ```echo "ClientAliveInterval 120\nClientAliveCountMax 720" > /etc/ssh/sshd_config```.\
Server makes client send 1 null packet every 120s a maximum of 720 times. 120*720=24 hours. 

### FTP Vs SFTP Vs SSHFS
* FTP: Comes in the form of vsftpd. I use this on my VPS because its easier to set up and easier (but not as secure) to connect to.
* SFTP: Comes in the form of OpenSSH. I use this on my main arch machine because its secure af (but harder to set up).
* SSHFS: an extension for connecting to a SFTP server on the clients side that lets you mount the server as a network drive (thunar allows this)

### Mounting a remote network through SSHFS
##### SSHFS Vs SFTP
* SFTP is a common protocol for graphical ftp clients such as filezilla or network drive mounting with Thunar.

* SSHFS is easier to configure and more lightweight than using virtual file systems inside your graphical file manager. Instead you mound a drive over the command line.
* SSHFS runs over SFTP and therefore you need port 22 open.
* SSHFS also avoids having to create *sftp exclusive* users who are unnable to SSH into the server. for example:
```
Match group sftp
ChrootDirectory /home
X11Forwarding no
AllowTcpForwarding no
ForceCommand internal-sftp <- this command will only allow sftp
```

1. Make sure port 22 is open on the server you are connecting to ```sudo ufw status``` and enable port 22 if needed with ```sudo ufw allow 22```. Also make sure you have the packages openssh, sshfs, openssh-server, and fuse.

2. The next thing to do is make sure ```/etc/ssh/sshd_config``` contains the correct path to your sftp server. On my current system (ubuntu 18.04) the rule i have is ```Subsystem       sftp    /usr/lib/openssh/sftp-server```. A hint to finding the location is to use ```whereis sftp-server```.

3. Create a SSH key and copy it to the server to make logging in secure and easier in the future. ```ssh-keygen``` ```ssh-copy-id roland@11.22.33.44```. Then Create an entry in ~/.ssh/config with an alias for the server because sshfs reads the *ssh pub key* from this config to authenticate with the server. 
```
Host TestServer
  HostName 11.22.33.44
  User roland
  Port 22
  IdentityFile /home/roland/.ssh/id_rsa
```

4. To Mount the remote filesystem on your device run the command ```sshfs -F /home/roland/.ssh/config roland@45.77.236.124:/home/roland mount/```. Add
```-o debug``` to enable debugging information

### Thunar Freezes when a NFS drive is connected
Make sure ```nfs-utils``` is installed on the system. Once installed restart Thunar's daemon with ```thunar -q``` or kill it with ```sudo pkill thunar```.
You can also try to unmount the drive with ```sudo umount -af -t nfs```

### Cannot write to files on NFS
This happens when an ftp connection is being used. this is unsecure so you cannot write. 
However if you know you are using a secure connection it may be because of file permissions. The following steps are debug instructions to debug that.
1. Create a folder to permit access to ```mkdir -p /home/myNFSFolder```
2. assign your *sftp group* access to the folder ```sudo chgrp someGroup /home/myNFSFolder```
3. Make the fodler writable ```sudo chmod 775 /home/myNFSFolder```
4. Set the GID for all subfolders too ```sudo chmod g+s /home/myNFSFolder```
Make sure the user is in the correct group with the ```groups 'username'`` command and add them if not. 

### Hardening SSH access
limit connection attempts per minute ```sudo apt-get install ufw && sudo ufw limit OpenSSH```

### Log in with no password with SSH
1. Generate a new rsa key with ```ssh-keygen```. Do not specify a password when asked.
2. Add this key to the list of keys that ssh will ask when authenticating ```ssh-add ~/.ssh/id_nopass_rsa```. This list is a global list of possible ssh keys that your client will try against the server.

### Debugging SSH
##### Connection closed by 45.77.236.124 port 22
check the system time which is one of the MANY causes for this problem. (see *My Time and Date are all fucked up*)

# User account administration
### Add a user
```sudo adduser roland```
```sudo usermod -aG sudo roland```\
-aG **A**ppend the '*sudo*' **G**roup to the user.

### List all users
```cat /etc/passwd```

### List all groups
```cat /etc/group```

### See the groups a user is in
```groups USERNAME``` or ```groups``` for to display the current user

### Create a new group
```sudo addgroup GROUPNAME```. the groupname can be anything. For example an sftp group could be ```sudo addgroup sftp```

### Add a new group to a user
```usermod -G sudo,sftp,anothergroup roland```

# Generic issues
### Remove old boot entries (created by boot managers)
You can do this installed in the live media off a usb or in the full environment if you need to.
Run ```efibootmgr``` to see the list of boot entries. and then ```efibootmgr -b #### -B``` -b to specify the boot id and -B to specify delete.

### How to image an iso to a usb (create bootable media)
Use dd (data duplicator).
* if = input
* of = output
```sudo dd status=progress if=/name/of/iso of=/dev/sdX```

### How to wipe a drive
* You can use the ```wipe -r /dev/sdX```. command from the (repos)[https://www.archlinux.org/packages/extra/x86_64/wipe/]. This will do a quick erase of the disk.
* To entirely nuke a drive (similar to DBAN) use the ```shred``` command - ```shred -v /dev/sdX```. -v for verbose.

### Cant use echo in bash script.
Use printf instead.
```
lrus="hello"
printf 'test '${lrus}' test' ;
```

### sudo open a file in Ranger
press *space* to select the file then press *@* and type *sudo nano*

### Updating NPM and NODE to latest versions
NPM already should be the latest version. verify the version at the [website](https://www.npmjs.com/package/npm)

NODE however is not the latest version. update it by installing Node Version Manager (NVM) ((install instructions)[https://github.com/nvm-sh/nvm/blob/master/README.md]) and getting the latest version from the nvm script.

Once installed list avaliable versions with ```nvm ls-remote``` and install a version with ```nvm install x.x.x```.

### applications showing unrecognized characters (placeholders)
**WIP i am yet to actually solve this.**\
A first step to this problem is to install the noto-fonts package and supplicant packages.
* Get the standard noto fonts package ```sudo pacman -S noto-fonts noto-fonts-emoji``` 
* Chinese character support ```sudo pacman -S noto-fonts-cjk```

### VSCode cant save stuff as sudo
The regular official *code* package cannot do this according to the [wiki](https://wiki.archlinux.org/index.php/Visual_Studio_Code).
You can solve this by installing the AUR binary version thats contains proprietary stuff from microsoft [here](https://aur.archlinux.org/packages/visual-studio-code-bin/). 

### tree command using weird Characters
tree looks like this
```
.
|-- zprofile
`-- zshenv
```
But should look like:
```
.
├── zprofile
└── zshenv
```
This is caused by a localisation issue. export these variables into your shell (.xsession or bashrc/zshrc).
```
export LANG=en_US.UTF-8 
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
```

### Flameshot doesnt run
This issue happened when i switched over from a display manager (sddm) to xorg-xinit (~/.xinitrc).
```flameshot``` froze the terminal and ```flameshot gui``` simply didnt start the application.

I think i solved this issue by changing my .xinitrc so that it uses dbus_launch to launch the desktop. ```exec dbus-launch openbox-session```

### See list of uninstalled packages in pacman
```grep 'removed' /var/log/pacman.log```

### Boot stuck on ```Reached target graphical interface```
This is an ongoing issue that i have had with my home computer. I havent solved it yet but here is what i have done so far.
* Make journalctl log bigger. this avoids journalctl being *rotated* which can display when looking at the systemctl status of some process, ie. when it freezes and you ctrl+alt+f2 to look at the status of sddm to see what its doing. ```sudo journalctl --verify``` and ```journalctl --vacuum-size=200M``` to Delete old logs for debugging.
* Install the *nvidia* package.

### Download stuff off a website where you cant FTP in
```wget -r website.com/directory/*``` Use a * to **r**ecursively download all files from that point onwards.

### Cannot find terminfo entry for 'some-terminal' when using screen over ssh.
My solution to this was to install the same terminal on the host im connecting to. 
This installs a terminfo file which you then need to export as a chosen terminal (export TERM=someterm)

### see the version of the OS i am on
```lsb-release -a``` OR ```hostnamectl```\
Rolling release distros like arch just say the release is 'rolling'. Whereas ubuntu has versions 'bionic', 'disco dingo', etc.

### see the kernal i am using
```uname```\
-r = release. (prints '5.4.1-arch1-1')\
-n = nodename/hostname (prints ...@'arch' or ...@'roland')\
-s = kernal (prints 'Linux')

### Figlet font locations:
```/usr/share/figlet/fonts``` (only .flf fonts seem to work)

### Recursive search folders and files for text:
```grep -rw . -e 'TextToSearch'```\
-r = recursive\
-w = match the whole word\
-e = use this pattern
-l can be added to just give the file name of matching files

You can also use a file of patterns to check (one per line)\
```grep -rw . -f patterns.txt```

### Can't connect to ftp server (Connection refused)
I had this issue with a VPS once. The solution was to open up the ports for ftp again on the host.
1. Make sure you have vsftpd installed (vsftpd (Very Secure File Transfer Protocol Deamon) is an ftp daemon that creates a server to connect to over ftp).
2. Connect to the host through the web terminal provided by the VPS provider.
```
firewall-cmd --permanent --add-port=21/tcp
firewall-cmd --permanent --add-service=ftp
firewall-cmd --reload
```
Furthermore there are a couple ways to check for open ports.
```sudo lsof -i -P -n | grep LISTEN```\
```sudo firewall-cmd --list-ports``` and ```sudo firewall-cmd --list-services```

### Errors When connecting to a ssh host and you get these errors when trying to use nano (eg. nano a > error):
```ERROR: /bin/sh: 1: /usr/bin/sensible-editor: not found```
```ERROR: Error opening terminal: xterm-kitty.```
```
# Solution
export TERM=xterm
```

### Check what filesystem type you are using.
```lsblk -f``` -f outputs info about filesystems

### My Time and Date are all fucked up D:
1. Verify your timezone ```timedatectl status```. 
2. See all available timezones with ```timedatectl list-timezones```
3. Finally, set your timezone with ```sudo timedatectl set-timezone Australia/Melbourne```.

If that doesnt work you should run ```timedatectl set-ntp true``` to set your network time back to true so it gets the time correctly.
```
# WRONG
Time zone: UTC (UTC, +0000)
# CORRECT
Time zone: Australia/Melbourne (AEDT, +1100)
```

### What does ```curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -``` Mean?
```Curl -s (silent) -L``` (follow redirects). Then pipe it and execute the script from the url in into bash and preserve the existing environment variables (-E), Finally the - means "the thing thats being piped".

##### Further explanation of the pipe part of the command:
```someCommand | **sudo** -E **bash** -```\
Pipe the command into bash (like running it as sudo in bash normally).\
```someCommand | sudo **-E** bash -```\
Preserve the environment variables in my bash environment\
```someCommand | sudo -E bash **-**```\
Substitute the result of someCommand into '-'

# Screen / multiplexing
### Screen Basics
A screen is essentially another tab. The number that a screen is given when creating it is its PID. You can then search for the process by using htop and typing the PID number to jump to it.

* Create a screen - 
* List all screens - ```screen -ls```
* Re-attach to a screen - ```screen -r 1234.myscreen```
* Leave a screen (without deleting it) - ```ctrl+a, d``` while connected to the screen press *ctrl+a* at the same time, then let go of *ctrl+a* and press *d* 
* Delete/remove a screen - ```ctrl+a, k``` while connected to the screen press *ctrl+a* at the same time, then let go of *ctrl+a* and press *k* 

# Database stuff
### Setting up mongodb
I am aiming to use the most modern version of mongodb (currently 4.2). You need to follow weird instructions to install 4.2 because its not in the regular packages. Instructions [here](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/).

MongoDB config files can be found at ```/etc/mongodb.conf```.

"By default, MongoDB runs using the mongodb user account." Though it has nologin privilages and so far i have found no good use for this information.

By default, MongoDBs database path (dbPath) is ```/var/lib/mongodb```.

1. Install mongodb ```sudo apt install mongodb```
2. Put mongo in your path. Check where mongo is installed with ```which mongo```. Your path will usually be something like ```PATH=/usr/bin/mongo:$PATH```
3. Unmask the mongod service because for some stupid reason its masked (masked is a more permanant version of disabled) 
```sudo systemctl unmask mongod```
4. Start mongo with ```mongod``` command. you should see *waiting for connections on port 27017*
5. Enable mongo as a service with ```sudo systemctl start mongodb``` and ```sudo systemctl enable mongodb```
If you type ```mongod``` again to try and start the service you will notice that it is already running. You can also confirm that mongo is running with ```sudo systemctl status mongodb```.\
At this stage you can see mongodb, and its PID running with ```sudo lsof -iTCP -sTCP:LISTEN```\
-iTCP = -i (select all of the) -TCP\
-sTCP:LISTEN = -s (filter) the -TCP ports that are is mode LISTEN

### Securing mongodb
its a good idea to require users to authenticate with the database.\
This also solves the **Access control is not enabled for the database** (happens on version 3.6) error.
1. create a privilaged superuser account to connect to the database with.
```
use admin
db.createUser(
  {
    user: "superuser",
    pwd: "password",
    roles: [ "root" ]
  }
)
```
2. edit ```/etc/mongod.conf``` and enable ```security.authorization```. This config files uses YAML markup.
```
security:
   authorization: true
```
3. Then restart yout mongodb server and it will read the config file and enable authentication\
```sudo systemctl start mongod```

###### Creating other types of mongodb users
Create an admin...
```
use admin
db.createUser(
  {
    user: "roland",
    pwd: "password",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
  }
)
```
Create a regular user...
```
use any_db_name_here
db.createUser(
  {
    user: "roland",
    pwd: "password",
    roles: [ { role: "readWrite", db: "any_db_name_here" } ]
  }
)
```
You need to restart mongodb for it to gain access control and to verify that the error message is gone:\
```mongod --auth --port 27017 --dbpath /data/db```\
You can then connect to the database as that user with:\
```mongo --port 27017 -u "myUserAdmin" -p "abc123" --authenticationDatabase "admin"```

# Nvidia Drivers
Nvidia is kinda a bitch to set up to work for multiple monitors and stuff.

### Basic setup
1. Install ```nvidia``` package and its dependencies onto your system.
2. Install ```nvidia settings``` package too for a settings window.

If you go and restart your system you may find that the system hangs at 'reached graphical target'. 
This is likely due to your ```/etc/X11/xorg.conf``` no longer playing nice with the nvidia drivers. 
Confirm this by changing tty on the boot screen (ctrl+alt+f2) and checking your display manage is not working ```systemctl status sddm```. Also run ```journalctl``` and have a look at the errors that were reported. In my case sddm had a 'core dump' and failed to fetch a display.

Temporaraly fix this error by running ```sudo nvidia-xconfig``` to overwrite your old xorg.conf with a new one generated by nvidia that plays nice with X and nvidia drivers. You should now restart and you should reach the display manager and desktop.

### Ditching nvidia config files for xrandr to fix screen tearing and monitor layout
Nvidia drivers might also break your monitor setup and create screen tearing. especially when with multihead setups.
While you can modify the */etc/X11/xorg.conf* and */etc/X11/xorg.conf.d/20-nvidia.conf* Files i am yet to solve the screen tearing and layout propperly with these configs.

The current way i am setting up my displays is with xrandr. This command will fully set up my monitors (and belongs in the .xinitrc when using startx):
```xrandr --output HDMI-0 --mode 1920x1080 --pos 1080x420 --output HDMI-1 --primary --mode 1920x1080 --pos 0x0 --rotate left```
Here are my other config files which currently dont do anything but i will still include for completeness sake
```
|-- xinitrc.d
|   |-- 05-device.conf
|   `-- 10-monitor.conf
`-- xserverrc
```

```
# /etc/X11/xinit/xinitrc.d/05-device.conf
Section "Device"
    Identifier "nvidia"
    Driver "nvidia"
    Option "Monitor-HDMI-0" "HDMI-0-monitor"
    Option "Monitor-HDMI-1" "HDMI-1-monitor"
EndSection
```

```
# /etc/X11/xinit/xinitrc.d/10-monitor.conf
Section "Monitor"
    Identifier "HDMI-0-monitor"
EndSection

Section "Monitor"
    Identifier "HDMI-1-monitor"
    Option "Rotate" "Left"
    Option "RightOf " "HDMI-0-monitor"
EndSection
```

### CLI configure displays
```nvidia-settings --assign CurrentMetaMode="HDMI-0: nvidia-auto-select +1080+420 {ForceCompositionPipeline=On}, HDMI-1: nvidia-auto-select +0+0{ForceCompositionPipeline=On, Rotation=90, primary=true}"```

# Input
I'm a HUGE fan of ergonomics and love making my daily computer use easier where possible.
* Keyboard: WASD V2 87
* Primary mouse: Elecom Huge BT
* Gaming mouse: Razer deathadder 2013

### Display mouse buttons when pressed
```xev | awk -F'[ )]+' '/^ButtonRelease/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'```

### Rebind a key
* install xdotools (execute virtual key events) and xbindkeys (rebind keys to do things when you press them)
You can check for Key IDs with either *xev* or *xbindkeys -k*
* You can see xdotools in action with an example command: 
1. ```sleep 0.5 && xdotool click 2``` Click the middle mouse button
2. ```sleep 0.5 && xdotool key 's'``` Type the S key
* Here is an example of an xbindkeys config
```
# /home/roland/.xbindkeysrc

# When you press a mouse button take a screenshot
"flameshot gui"
    m:0x0 + b:12   (mouse)

# When you press a mouse button press anopther mouse button
"sleep 0.2 && xdotool click 2"
    m:0x0 + b:10   (mouse)
```

### Scroll with the trackball
Set libinput Button Scrolling Button (283) to 9 *(9 is the mouse button number)*\
```sudo xinput set-prop 12 283 9```\
Then set libinput Scroll Method Enabled (281) to 0, 0, 1\
```sudo xinput set-prop 12 281 0, 0, 1```

# Things to learn still
- [ ] What's Polkit?
- [ ] QT vs GTK. configs, what uses these (openbox with which one, or both?)
- [ ] How to install an icon theme
- [ ] MERN Vs LAMP. Pros of using MERN stack and its applications for my projects (folio site)
  - [ ] What is a style loader
- [ ] What is conky?
- [ ] Docker
- [ ] rsync
- [ ] NFS in fstab, oh my!
- [ ] Understand file permissions
- [ ] sysfs, udev, dbus
- [ ] actually learn git properly
- [ ] VIM keys and VIM in general
- [ ] UEFI/EFI/BIOS booting and all that stuff
- [x] Debian/Ubuntu APT manager (should come back to this one again soon)
- [x] Difference between ```sudo apt-get update``` and ```sudo apt update```

# TODO
- [ ] Why do some fonts (wide fonts in particular) become unicode squares D:
- [ ] write some notes on the arch install process. short dotpoints for quick reference
- [ ] Configure polybar
- [ ] Create a script to toggle between scrolling and not scrolling for my trackball mouse to make it EVEN MOAR ERGO!
- [x] Why did my @roland account on my test server lose the ability to CD into folders (occurred after applying 'Cannot write to files on NFS')
- [x] Experiment with the python virtual environment
- [x] Create a React / Express / Webpack boilerplate to better understand MERN
---
# Non related linux things

# VS Code stuff
##### Quick and dirty fix to reformat shitty brackets propper brackets
```
distusting() {

}

this_is_better()
{

}
```
* find and replace
* replace {
* in the bottom box use ```shift+enter``` then type {
moves all the { to the next line. Works great with big stubborn css files

##### Show the code completion diologue again:
```ctrl+space```

# Random Stuff
### Append Vs overwrite file
* ```>``` Overwrite file
* ```>>``` Append to file

# MERN stuff
### webpack-dev-server not accessible from computers not on the same network
Notice that when you run ```webpack --mode development``` it says:
```
｢wds｣: Project is running at http://localhost:8080/
ℹ ｢wds｣: webpack output is served from /
ℹ ｢wds｣: Content not from webpack is served from /home/sftp_user/project
```

To fix this and access it from outside the network change the ```webpack.config.js``` to allow host 0.0.0.0 (any ip) to access the server.
```
devServer: {
    inline: true,
    contentBase: './public',
    port: 8080,
    host: '0.0.0.0'
  }
``` 
and add a firewall rule to allow whatever port you are using ```sudo ufw allow 8080```.

### NPX Vs NPM Vs NVM Vs NodeJS
#### NodeJS
Used to run javascript on a computer itself (outside of the browser). Ie. Running JS on a server to access OS related functions and Files on that computer (usually server) 
##### Global NodeJS objects
Objects that NodeJS provides 
* A *module* is any functions that are exported from a JS file
* *require()* allows you to import modules
* *process* is an object that refers the process (PID) that a NodeJS Program is running on
##### Provided NodeJS modules
* HTTP / HTTPS - for creating web servers
* File System, OS, and Path (working with file paths) 

#### NPM - Node Package Manager
A package manager for node. Loads packages from repos just like any other package manager (PIP, NUget, etc).
* Packages can be installed locally into a project directory under /node_modules
* Packages can be installed globally by passing ```npm install -g```

#### NPX - Node Package Executor
This is not a required part of the NodeJS ecosystem, rather it is a quality of life feature. NPX allows you to download a package you dont have and use a command from that package and then removing that package. Essentially treating that package like a make dependency.

#### NVM - Node Version Manager
Used to manager the version (or versions) of node that you have installed. You can manage (have downloaded) multiple versions of NodeJS but you can only use one. NVM enables this.
* NVM is useful to upgrade your version of node to a modern edition when using distros that dont ship modern versions of NodeJS.
  * see *Updating NPM and NODE to latest versions*