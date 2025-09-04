#!/bin/bash

TARGET_IP="IP"
MAX_PORT=100

echo "Scanning ports 1 to $MAX_PORT on $TARGET_IP..."
echo "----------------------------------------"

for port in $(seq 1 $MAX_PORT); do
    echo -n "port $port: "
    
    output=$(telnet $TARGET_IP $port)
    echo $output | tail -n 1
    
    sleep 0.1
done

echo "----------------------------------------"
echo "Scan completed."
