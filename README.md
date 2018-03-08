Pulse-Monitor
================================================================================

A client + server tool to to log and rectify communication problems. 

The Heartbeat computer (server or client--doesn't matter) delivers messages to a file on the Monitor computer via SSH. The Monitor checks the file and executes remedial action if conditions are met. Server and client can fill either role assuming a VPN or reverse SSH tunnel exist. Frequency, timeout, and remedial actions are all configurable.


Install
-------------------------------------------------------------------------------

### SSH Access

Requires the running user on the Heartbeat system to have key-based SSH access to the remote running user on Monitor system.

On Heartbeat system:

```
ssh-copy-id -i <KEY> <REM_USER>@<IP> -p <PORT>
```



### Installation

[1] Install the Heartbeat role first. On Heartbeat system:

```
git clone https://github.com/viiateix/Pulse-Monitor.git
cd Pulse-Monitor
./install-heartbeat.sh <FREQ> <KEY> <USER> <IP> <PORT> <FILE> "<MSG>"
```

where 

- FREQ is how many minutes (integer) between sending heartbeats
- KEY is the SSH key for logging in to the Monitor
- USER is the user for logging in to the Monitor
- IP is the IP address of the Monitor
- PORT is the SSH port of the Monitor
- FILE is the heartbeat log file on the Monitor
- MSG is the message to be appended to the heartbeat log, in quotes

Example:

```
./install-heartbeat.sh 2 /home/user/.ssh/id_rsa remoteuser 12.34.56.78 22 /home/remoteuser/heartbeat.log "Hello there"'
```

[2] Then install the Monitor role. On the Monitor system:

```
git clone https://github.com/viiateix/Pulse-Monitor.git
cd Pulse-Monitor
./install-monitor.sh <FREQ> <FILE> <TIMEOUT> "<ACTION>"
```

where

- FREQ is how often (integer minutes) to check FILE for "last modified"
- FILE is the heartbeat log that receives messages from Heartbeat
- TIMEOUT is how old a "last modified" time can be before running ACTION
- ACTION is a command (can point to a script) in quotes

Example:

```
./install-monitor.sh 1 /home/user/heartbeat.log 5 "/sbin/reboot"
```

