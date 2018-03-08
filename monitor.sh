#!/bin/bash
# monitor.sh
################################################################################
# Monitors for changes to heartbeat log file.                                  #
#                                                                              #
# Calls to this script are configured by install-monitor.sh.                   #
#                                                                              #
# Must be run as superuser if <ACTION> requires superuser privilege.           #
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
  echo '  ./monitor.sh <FILE> <TIMEOUT> "<ACTION>"                                '
  echo 'where:                                                                    '
  echo '  - FILE is the heartbeat log that receives messages from Heartbeat       '
  echo '  - TIMEOUT is how old a "last modified" time can be before running ACTION'
  echo '  - ACTION is a command (can point to a script) in quotes                 '
  echo 
  echo 'example:                                                                  '
  echo '  ./monitor.sh /home/user/heartbeat.log 5 "/sbin/reboot"                  '
}

####################################################################### ARGUMENTS
# ARGUMENT: Check for help request
if [[ "$1" -eq "-h" ]] || [[ "$1" -eq "--help" ]]
then
  usage
  exit 0
fi

# ARGUMENT: Check for correct quantity arguments
if [[ $# -ne 3 ]]
then
  echo "${BrRed}[!] ERROR - Invalid arguments.${NC}"
  usage
  exit 1
fi

   FILE="$1"
TIMEOUT="$2"
 ACTION="$3"

########################################################################## SCRIPT
# How many seconds before file is deemed "older"
OLDTIME=$((TIMEOUT * 60))

# Get current and file times
 CURTIME=$(date +%s)
FILETIME=$(stat $FILE -c %Y)
TIMEDIFF=$(expr $CURTIME - $FILETIME)

# Check if file older
if [[ $TIMEDIFF -gt $OLDTIME ]]
then
  "$ACTION"
fi






