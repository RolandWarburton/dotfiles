# Remove FF tmp donwload location if it exists
if [ -d "/tmp/code.deb" ]
then
	echo "Removing old code"
	sudo rm -rf /tmp/code.deb
fi

# install pre-reqs
sudo apt install software-properties-common apt-transport-https curl

# Install microsoft gpg key
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/microsoft.gpg
sudo install -o root -g root -m 644 /tmp/microsoft.gpg /usr/share/keyrings/microsoft-archive-keyring.gpg
rm /tmp/microsoft.gpg

# Install source
sudo sh -c 'echo "deb [arch=amd64, signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

sudo apt update
sudo apt install code

