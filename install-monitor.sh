#!/bin/bash
# install-monitor.sh
################################################################################
# Installs and configures Pulse Monitor's Monitor role for current user.       #
#                                                                              #
# Must be run as superuser if <ACTION> requires superuser privilege.           #
#                                                                              #
# Requires key-authorized SSH login to this user by remote user already set.   #
#                                                                              #
# Ensure <FILE> is same as used in install-heartbeat.sh on the Heartbeat sys.  #
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
  echo '  ./install-monitor.sh <FREQ> <FILE> <TIMEOUT> "<ACTION>"                 '
  echo 'where:                                                                    '
  echo '  - FREQ is how often (integer minutes) to check FILE for "last modified" '
  echo '  - FILE is the heartbeat log that receives messages from Heartbeat       '
  echo '  - TIMEOUT is how old a "last modified" time can be before running ACTION'
  echo '  - ACTION is a command (can point to a script) in quotes                 '
  echo 
  echo 'example:                                                                  '
  echo '  ./install-monitor.sh 1 /home/user/heartbeat.log 5 "/sbin/reboot"        '
}

####################################################################### ARGUMENTS
# ARGUMENT: Check for help request
if [[ "$1" -eq "-h" ]] || [[ "$1" -eq "--help" ]]
then
  usage
  exit 0
fi

# ARGUMENT: Check for correct quantity arguments
if [[ $# -ne 4 ]]
then
  echo "${BrRed}[!] ERROR - Invalid arguments.${NC}"
  usage
  exit 1
fi

   FREQ="$1"
   FILE="$2"
TIMEOUT="$3"
 ACTION="$4"

########################################################################## SCRIPT
# PREP
# Install moreutils - Includes timestamp (ts)
cp ~/Pulse-Monitor/ts /usr/bin/ts
chmod +x /usr/bin/ts

# Make monitor.sh executable in case it isn't
cd ~/Pulse-Monitor
chmod +x monitor.sh

# Create name for temporary cronfile
CRONFILE="`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 8`"

# Create cron line
PWD="`pwd`"
CRONLINE="*/$FREQ * * * *  $PWD/monitor.sh $FILE $TIMEOUT \"$ACTION\""



# EXECUTE
# Copy crontab to temporary file for modification
crontab -l                                                       > /tmp/$CRONFILE
echo "${BrBlue}[*] Copied crontab to /tmp/$CRONFILE.${NC}"

# Add line to temporary crontab
echo "$CRONLINE"                                                >> /tmp/$CRONFILE
echo "${BrBlue}[*] Added to temporary crontab: $CRONLINE${NC}"

# Load temporary crontab file into actual crontab
echo "${BrBlue}[*] Loading modified crontab to schedule all scripts...${NC}"
crontab                                                            /tmp/$CRONFILE
echo "${BrBlue}[*] Complete.${NC}"

exit 0


