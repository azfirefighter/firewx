#!/bin/bash
#
# Setup script for firewx
#
# This will NOT install anything.  THAT will be up to YOU.
#
clear
dir=$(pwd)
echo -e "-------------------------------------------------------------------------------"
echo -e "Using this directory ($dir)."
echo -e "-------------------------------------------------------------------------------"
echo -e "\n"

# Search for required GNU commands.
echo -e "-------------------------------------------------------------------------------"
echo "Searching for required GNU commands."
echo -e "-------------------------------------------------------------------------------"
if [ -e "/usr/bin/tr" ]
then
	echo -e "FOUND: 'tr' at $(which tr)!"

else
	echo -e "ERROR: 'tr' NOT found.  Quitting!"
	exit 1
fi

if [ -e "/usr/bin/cut" ]
then
	echo -e "FOUND: 'cut' at $(which cut)!"

else
	echo -e "ERROR: 'cut' NOT found.  Quitting!"
	exit 1
fi

if [ -e "/usr/bin/awk" ]
then
	echo -e "FOUND: 'awk' at $(which awk)!"

else
	echo -e "ERROR: 'awk' NOT found.  Quitting!"
	exit 1
fi

if [ -e "/usr/bin/sed" ]
then
	echo -e "FOUND: 'sed' at $(which sed)!"

else
	echo -e "ERROR: 'sed' NOT found.  Quitting!"
	exit 1
fi

if [ -e "/usr/bin/wget" ]
then
	echo -e "FOUND: 'wget' at $(which wget)!"

else
	echo -e "ERROR: 'wget' NOT found.  Checking for curl."
		if [ -e "/usr/bin/curl" ]
		then
			echo -e "FOUND 'curl' at $(which curl) instead of wget."
			echo -e "You're going to have to modify the weather.sh script."
		fi
	exit 1
fi
read -p "Press any key to continue."

# Check for other required programs
echo -e "\n"
echo -e "-------------------------------------------------------------------------------"
echo -e "Checking for required build system."
echo -e "-------------------------------------------------------------------------------"
which {python3,pip3,ruby,bundle,jekyll,make,gcc}
if [ $? != 0 ]
then
	echo "ERROR: Make sure you have the following installed on your system:"
	echo "python3, pip3, ruby, bundle, jekyll, make, gcc"
	while which {apt,yum}; do echo "Your package management program is $0\n Try installing with sudo $0 python3 pip3 ruby bundle jekyll make gcc"; done
	echo "Quitting."
	exit 1
fi
echo "Found required build system commands!"
echo "Updating bundle.  You may be asked for your password."
bundle install
bundle package
read -p "Press any key to continue."

echo -e "\n"
echo -e "-------------------------------------------------------------------------------"
echo "Installing wxcast program."
echo -e "-------------------------------------------------------------------------------"
which wxcast
if [ $? != 0 ]
then
	echo "Using 'sudo pip3 install -r requirements.txt' to install wxcast.  You will be asked for your password."
	sudo pip3 install -r requirements.txt
	if [ $? != 0 ]
	then
		echo "Unable to install wxcast.  You may have to do it manually with 'sudo pip3 install wxcast'."
		exit 1
	fi
fi
wxcast=$(which wxcast)
echo -e "'wxcast' installed."
read -p "Press any key to continue."

echo -e "\n"
echo -e "-------------------------------------------------------------------------------"
echo -e "\nGREAT!  Continuing with configuration."
echo -e "-------------------------------------------------------------------------------"

read -p "Enter the web server directory path for the HTML file: " webhome
read -p "Enter the web URL for the HTML file: " url
read -p "Enter the email address that notifications will come FROM: " from
read -p "Enter the email address to send notifications TO: " email
read -p "Enter your zip code (5 nubmers only): " zipcode
echo -e "-------------------------------------------------------------------------------"
read -p "Enter the title for the web page: " title
read -p "Enter the file name for the logo image: " logo


# Find the NWS office for user
echo "You will be looking for the line that says 'Location:' and has a long URL."
echo "Look for the section in Location that says 'site=' and is followed by three letters."
echo "Write down those three letters."
read -p "Ready?  Press any key to continue."
clear
wget -S -qO- https://forecast.weather.gov/zipcity.php?inputstring=$zipcode | grep Location\:
read -p "Enter the three letters you wrote down: " office
echo -e "\n"

# Install crontab
echo -e "\n"
echo -e "-------------------------------------------------------------------------------"
echo -e "\nInstalling crontab file."
echo -e "-------------------------------------------------------------------------------"
user=$(whoami)
echo "MAILTO=''" > crontab.install
echo "0 4-19 * * * $dir/weather.sh >/dev/null 2>&1" >> crontab.install
echo "0 5 * * * $dir/send-mail.sh >/dev/null 2>&1" >> crontab.install
crontab -u $user crontab.install
sudo systemctl restart crond

# Build the required files
echo -e "\n"
echo -e "-------------------------------------------------------------------------------"
echo -e "\nBuilding configuration files."
echo -e "-------------------------------------------------------------------------------"
echo "#!/bin/bash\n" > config
echo "# Generated by configure.sh at $(date)" >> config
echo "#" >> config
echo "dir=$(pwd)" >> config
echo "wxcast=$(which wxcast)" >> config
echo "webhome=$webhome" >> config
echo "url='$url'" >> config
echo "email='$email'" >> config
echo "from='$from'" >> config
echo "office=$office" >> config
echo "zipcode=$zipcode" >> config
echo "user=$user" >> config

echo "---" > index.md
echo "layout: default" >> index.md
echo "version: $(cat VERSION)" >> index.md
echo "github: azfirefighter" >> index.md
echo "author: Jason Todd" >> index.md
echo "license: LICENSE" >> index.md
echo "logo: $logo" >> index.md
echo "title: $title" >> index.md
echo "---" >> index.md


echo -e "-------------------------------------------------------------------------------"
echo -e "Configuration complete!"
echo -e "You are probably going to have to edit the weather.sh file to get and display"
echo -e "the weather data for your area."
echo -e "-------------------------------------------------------------------------------"

