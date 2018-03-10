#!/bin/bash
# install-heartbeat.sh
################################################################################
# Installs and configures Pulse Monitor's Heartbeat role for current user.     #
#                                                                              #
# Requires key-authorized SSH login by this user to remote user already set.   #
#                                                                              #
# Ensure <FILE> is the same as used in install-monitor.sh on the Monitor sys.  #
#                                                                              #
# Designed to run on Ubuntu 16.04 x86_64.                                      #
################################################################################

######################################################################### BCOLORS
# bcolors: echo "${RED}Warning: Something! Continue?${NC} "
Black=$'\033[0;30m'
BrBlack=$'\033[1;30m'
Red=$'\033[0;31m'
BrRed=$'\033[1;31m'
Green=$'\033[0;32m'
BrGreen=$'\033[1;32m'
Yellow=$'\033[0;33m'
BrYellow=$'\033[1;33m'
Blue=$'\033[0;34m'
BrBlue=$'\033[1;34m'
Purple=$'\033[0;35m'
BrPurple=$'\033[1;35m'
Cyan=$'\033[0;36m'
BrCyan=$'\033[1;36m'
White=$'\033[0;37m'
BrWhite=$'\033[1;37m'
Bold=$'\033[1m'
Underline=$'\033[4m'
NC=$'\033[0m'

####################################################################### FUNCTIONS
usage () { 
  echo 'usage:                                                                    '
  echo '  ./install-heartbeat.sh <FREQ> <KEY> <USER> <IP> <PORT> <FILE> "<MSG>"   '
  echo 'where:                                                                    '
  echo '  - FREQ is how many minutes (integer) between sending heartbeats         '
  echo '  - KEY is the SSH key for logging in to the Monitor                      '
  echo '  - USER is the user for logging in to the Monitor                        '
  echo '  - IP is the IP address of the Monitor                                   '
  echo '  - PORT is the SSH port of the Monitor                                   '
  echo '  - FILE is the heartbeat log file on the Monitor                         '
  echo '  - MSG is the message to be appended to the heartbeat log, in quotes     '
  echo 
  echo 'example:                                                                  '
  echo '  ./install-heartbeat.sh 2 /home/user/.ssh/id_rsa remoteuser 12.34.56.78 22 /home/remoteuser/heartbeat.log "Hello there"'
}

####################################################################### ARGUMENTS
# ARGUMENT: Check for help request
if [[ "$1" -eq "-h" ]] || [[ "$1" -eq "--help" ]]
then
  usage
  exit 0
fi

# ARGUMENT: Check for correct quantity arguments
if [[ $# -ne 7 ]]
then
  echo "${BrRed}[!] ERROR - Invalid arguments.${NC}"
  usage
  exit 1
fi

echo "${BrBlue}[*] Beginning heartbeat installation.${NC}"


FREQ="$1"
 KEY="$2"
USER="$3"
  IP="$4"
PORT="$5"
FILE="$6"
 MSG="From `hostname`: $7"

echo "${BrBlue}[*] Set variables by arguments.${NC}"


########################################################################## SCRIPT
# PREP
# Install moreutils - Includes timestamp (ts)
cp ~/Pulse-Monitor/ts /usr/bin/ts
echo "${BrBlue}[*] Copied custom timestamp file ~/Pulse-Monitor/ts to /usr/bin/ts.${NC}"
chmod +x /usr/bin/ts
echo "${BrBlue}[*] Made /usr/bin/ts executable.${NC}"


# Create name for temporary cronfile
CRONFILE="`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 8`"
echo "${BrBlue}[*] Temporary cronfile: $CRONFILE.${NC}"

# Create cron line ################################################### ERROR NEXT LINE
CRONLINE1="*/$FREQ * * * *  /usr/bin/ssh -i $KEY $USER@$IP -p $PORT echo "
CRONLINE2='$(ts '[\%Y-\%^b-\%d \%H:\%M:\%S \%Z]')'
CRONLINE3=" $MSG >> $FILE 2>&1"
echo "${BrBlue}[*] Line to be added to crontab: $CRONLINE.${NC}"




# EXECUTE
# Copy crontab to temporary file for modification
crontab -l                                                       > /tmp/$CRONFILE
echo "${BrBlue}[*] Copied crontab to /tmp/$CRONFILE.${NC}"

# Add line to temporary crontab
echo -n "$CRONLINE1"                                            >> /tmp/$CRONFILE
echo -n '$(ts '[\%Y-\%^b-\%d \%H:\%M:\%S \%Z]')'                >> /tmp/$CRONFILE
echo    "$CRONLINE3"                                            >> /tmp/$CRONFILE
echo "${BrBlue}[*] Added to temporary crontab: $CRONLINE${NC}"

# Load temporary crontab file into actual crontab
echo "${BrBlue}[*] Loading modified crontab to schedule all scripts...${NC}"
crontab                                                            /tmp/$CRONFILE
echo "${BrBlue}[*] Complete.${NC}"

exit 0


