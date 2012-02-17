#!/bin/bash

# Random file name
current_time="`date +%F_%Hh%Mm%Ss`"
file_name="${RANDOM}${RANDOM}${PID}_${current_time}.jpg"
subject_date="`date +%c`"
recipient="jespinal@CC-IT-38.cc.amsud.com" 
ccrecipient="jperez@CC-IT-42.cc.amsud.com"

# Function to test if a binary is present on the system
function isPresent {
	if [ -z "`dpkg --get-selections | grep -i "$1" | cut -f1`" ]; then
		ls "$RANDOM $RANDOM" 2>/dev/null 1>&2
	else
		ls . 1>/dev/null 2>&1
	fi
}

# Function to send generated file
function sendMail {
	mutt -s "${HOSTNAME} machine screenshot at [${subject_date}]" -a /tmp/${file_name} -c "${ccrecipient}" -- ${recipient} </dev/null 
}

# Function to create screenshot
function createImg {
	import -window root -strip -resize 85% -quality 75 /tmp/${file_name}
}

function cleanAll {
	rm -rf /tmp/${file_name}
}

#function uploadFile {
#	ncftpput -u   remote-host remote-directory local-files...
#}

isPresent "imagemagick";

# Is imagemagick present?
if [ $? != 0 ]; then
	echo "Imagemagic needs to be installed"
	sudo apt-get install imagemagick -y
fi

isPresent "mutt";

# Is mutt present?
if [ $? != 0 ]; then
	echo "mutt needs to be installed"
	sudo apt-get install mutt -y
fi

isPresent "ncftp";
if [ $? != 0 ]; then
	echo "ncftp needs to be installed"
	sudo apt-get install ncftp -y
fi

# Creating screenshot
createImg

# Sending image
# sendMail

# Cleaning before exiting
cleanAll
