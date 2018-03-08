Pulse-Monitor
================================================================================

A client + server tool to to log and rectify communication problems. 

The Heartbeat computer (server or client--doesn't matter) delivers messages to a file on the Monitor computer via SSH. The Monitor checks the file and executes remedial action if conditions are met. Server and client can fill either role assuming a VPN or reverse SSH tunnel exist. Frequency, timeout, and remedial actions are all configurable.

NOTE: Pulse-Monitor is designed to take a specific action when the Monitor system loses touch with the Heartbeat system. An alternate use, however, is to install only the Heartbeat role. This essentially builds a logging system in which the Monitor system (with no Pulse-Monitor components installed) has a log file that is updated regularly by the Heartbeat system, per arguments supplied to ./install-heartbeat.sh. In this setup, no logic is performed on any missed heartbeats, so the Monitor system takes no action. It does make for a handy heartbeat/connectivity logging tool, though.


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

