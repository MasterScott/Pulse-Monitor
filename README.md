# Pulse-Monitor
A client + server tool to to log and rectify communication problems. The Heart delivers a heartbeat message to a file on the Monitor via SSH. The Monitor checks the file and executes remedial action if conditions are met. Server and client can fill either role assuming a VPN or reverse SSH tunnel exist. Frequency, timeout, and remedial actions are all configurable.
