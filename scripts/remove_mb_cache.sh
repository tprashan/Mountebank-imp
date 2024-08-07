#!/bin/bash

# Base URL for Mountebank
MB_URL="http://localhost:2525"

# Path to your imposter configuration file
IMPOSTERS_CONFIG="./mb/imposters-new.json"

# Fetch all imposters
IMPOSTERS=$(curl -s $MB_URL/imposters)

# Extract the list of imposter ports
PORTS=$(echo $IMPOSTERS | jq '.imposters[].port')

# Loop through each port and delete the imposter
for PORT in $PORTS; do
    echo "Deleting imposter on port $PORT"
    curl -X DELETE "$MB_URL/imposters/$PORT"
done

# Re-add imposters from the specified configuration file
echo "Re-adding imposters from $IMPOSTERS_CONFIG"
curl -X POST -d @$IMPOSTERS_CONFIG $MB_URL/imposters
