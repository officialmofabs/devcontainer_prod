#!/bin/bash
# Restart SSH service without prompting for a password
sudo /etc/init.d/ssh restart

# Run the application without elevated privileges
exec /app/code tunnel
