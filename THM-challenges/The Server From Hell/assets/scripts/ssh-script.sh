#!/bin/bash

# Configuration
HOST="hell"
USER="hades"
KEY_FILE="id_rsa"
START_PORT=2500
END_PORT=4500
THREADS=50

# Set proper key permissions
chmod 600 "$KEY_FILE"

echo "🔍 Scanning ports $START_PORT to $END_PORT for abnormal SSH responses..."
echo "Target: $USER@$HOST"
echo "--------------------------------------------"

# Function to test a single port
test_port() {
    local port=$1
    local output
    local last_line
    
    # Capture SSH output with timeout
    output=$(timeout 4 ssh -o BatchMode=yes -o ConnectTimeout=3 -o StrictHostKeyChecking=no \
                         -i "$KEY_FILE" -p $port $USER@$HOST 2>&1)
    
    # Get the last line
    last_line=$(echo "$output" | tail -1)
    
    # Check if last line does NOT contain typical connection reset/refused messages
    if ! echo "$last_line" | grep -q "Connection reset by\|Connection refused\|Connection closed\|No route to host"; then
        if [ -n "$last_line" ]; then
            echo "Port $port: $last_line"
        else
            echo "Port $port: No typical error message (different response)"
        fi
    fi
}

export -f test_port
export HOST USER KEY_FILE

# Scan all ports in parallel, wait for all to complete
seq $START_PORT $END_PORT | xargs -I {} -P $THREADS bash -c 'test_port "$@"' _ {}

echo "--------------------------------------------"
echo "Scan completed. Check above for ports with unusual responses."
