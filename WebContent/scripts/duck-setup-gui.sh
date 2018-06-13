#!/bin/bash
# Duck DNS setup GUI version 1.0
# by The Fan Club - November 2013
#  
# This script should work on most unix/linux based systems
# that use bash and have cron and zenity installed 
# Tested on Ubuntu, Raspbian, and OSX 
#
# For more information about Duck DNS - http://www.duckdns.org/
#
userHome=$(eval echo ~${USER})
duckPath="$userHome/duckdns"
duckLog="$duckPath/duck.log"
duckScript="$duckPath/duck.sh"
echo "* Duck DNS setup by The Fan Club - version 1.0"
echo 

# Remove Option
case "$1" in
	remove)
      zenity --question --title "The Fan Club - Duck DNS Setup" --text "Completely remove Duck DNS settings?"  
      if [ "$?" -eq "1" ]
        then
          echo "Setup cancelled. Program will now quit."
         exit 0 
      fi
      # Remove Duck DNS files
      rm -R $duckPath
      # Remove Cron Job
      crontab -l >/tmp/crontab.tmp
      sed -e 's/\(^.*duck.sh$\)//g' /tmp/crontab.tmp  | crontab
      rm /tmp/crontab.tmp  
      zenity --info --title="The Fan Club - Duck DNS Setup" --text="<b>Duck DNS un-install complete</b>\n\n- Duck DNS script removed\n- Duck DNS folder removed\n- Duck DNS cron job removed" --ok-label="Done" 
      exit 0        
	;;
	
esac

# Main Install ***
# Get sub domain 
domainName=$( zenity --entry --title "The Fan Club - Duck DNS Setup" --text "Enter your Duck DNS sub-domain name" --ok-label="Next" --width="500")
mySubDomain="${domainName%%.*}"
duckDomain="${domainName#*.}"
if [ "$duckDomain" != "duckdns.org" ] && [ "$duckDomain" != "$mySubDomain" ] || [ "$mySubDomain" = "" ]
then 
  zenity --error --text="Invalid domain name. The program will now quit." --title "The Fan Club - Duck DNS Setup"
  exit 0
fi
# Get Token value
duckToken=$( zenity --entry --title "The Fan Club - Duck DNS Setup" --text "Enter your Duck DNS Token value" --ok-label="Next" --width="500")
# Display Confirmation
zenity --question --title="The Fan Club - Duck DNS Setup" --text="<b>Your domain name is $mySubDomain.duckdns.org \nand token value $duckToken</b>\n\nPlease click Next to continue or Cancel to quit.\nIt will take a few seconds for the setup to complete." --ok-label="Next" --cancel-label="Cancel"
# Check if Cancel was pressed
if [ "$?" -eq "1" ]
  then
    zenity --warning --text="Setup canceled" --title "The Fan Club - Duck DNS Setup" --width="300" --ok-label="Done"
    exit 0
fi
# Create duck dir
if [ ! -d "$duckPath" ] 
then
  mkdir "$duckPath"
fi
# Create duck script file
echo "echo url=\"https://www.duckdns.org/update?domains=$mySubDomain&token=$duckToken&ip=\" | curl -k -o $duckLog -K -" > $duckScript
chmod 700 $duckScript
# Create Conjob
# Check if job already exists
checkCron=$( crontab -l | grep -c $duckScript )
if [ "$checkCron" -eq 0 ] 
then
  # Add cronjob
  echo "Adding Cron job for Duck DNS"
  crontab -l | { cat; echo "*/5 * * * * $duckScript"; } | crontab -
fi
# Test Setup
# Run now
$duckScript
# Response
duckResponse=$( cat $duckLog )
if [ "$duckResponse" != "OK" ]
then
  responseExtra="[Error] Duck DNS did not update correctly.\n\nPlease check your settings or run the setup again."
else
  responseExtra="Duck DNS setup complete."
fi
# Setup report
zenity --info --title="The Fan Club - Duck DNS Setup" --text="<b>- Duck DNS script file created\n- Duck DNS cron job added\n- Duck DNS server response : $duckResponse</b>\n\n$responseExtra" --ok-label="Done" 
exit 
