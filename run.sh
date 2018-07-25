#!/bin/bash

# Start the web server
nohup ./server.sh & &> /dev/null

# Run the Client
./drinkdb.sh

# Cleanup
kill $(ps aux | grep ./server.sh | grep -v grep | awk '{print $2}')
