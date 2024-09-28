# Script to test interfacing with Linux syslog and rsyslog

import os
import socket

# Log constants according to RFC 3164
LOG_FACILTIY = 1 << 3       # 1 << 3 equals 1*2^3 as required by RFC 3164
LOG_SEVERITY = 6            # Severity for informational logs as defined by RFC 3164

# Logging message must be lead by priority value
app = "CustomLoggingApp"
priority = LOG_FACILTIY+LOG_SEVERITY
message = f"<{priority}> {app}: This is a test message"

# Open sockets to unix dev/log
log_socket = socket.socket(socket.AF_UNIX, socket.SOCK_DGRAM)
log_socket.connect('/dev/log')

# Send message to the socket
log_socket.sendall(message.encode('utf-8'))

# Close the socket
log_socket.close()