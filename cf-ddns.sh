#!/bin/bash

# Cloudflare config
ZONE_ID="<ZONE_ID>"
RECORD_ID="<RECORD_ID>"
API_TOKEN="<TOKEN>"
RECORD_NAME="<RECORD_NAME>"

# File to save ip
IP_FILE="/tmp/current_ip.txt"

# Get current ip public
CURRENT_IP=$(curl -s https://api.ipify.org)


log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Read old ip
if [ -f "$IP_FILE" ]; then
    OLD_IP=$(cat "$IP_FILE")
else
    OLD_IP=""
fi

# Check ip and change if ip have already changed
if [ "$CURRENT_IP" != "$OLD_IP" ]; then
    log "IP changed: $OLD_IP → $CURRENT_IP"
    
    RESPONSE=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
        -H "Authorization: Bearer $API_TOKEN" \
        -H "Content-Type: application/json" \
        --data "{
            \"type\": \"A\",
            \"name\": \"$RECORD_NAME\",
            \"content\": \"$CURRENT_IP\",
            \"ttl\": 60,
            \"proxied\": false
        }")

    # Check result
    if echo "$RESPONSE" | grep -q "\"success\":true"; then
        log "$CURRENT_IP" > "$IP_FILE"
        log "DNS updated successfully!"
    else
        log "Failed to update DNS!"
        log "$RESPONSE"
    fi
else
    log "IP not changed ($CURRENT_IP)"
fi

