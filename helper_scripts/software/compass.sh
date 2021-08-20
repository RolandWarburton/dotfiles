# Remove FF tmp donwload location if it exists
if [ -d "/tmp/compass.deb" ]
then
	echo "Removing old compass deb"
	sudo rm -rf /tmp/compass.deb
fi

sudo apt update
sudo apt install wget gconf-service gconf2-common libgconf-2-4

wget -O /tmp/compass.deb "https://downloads.mongodb.com/compass/mongodb-compass_1.28.1_amd64.deb"

yes | sudo dpkg -i /tmp/compass.deb && rm /tmp/compass.deb
