#!/bin/bash

# 1. Parse JSON from Stdin (Terraform passes the 'query' block here)
# We use jq to extract variables safely
eval "$(jq -r '@sh "HOST=\(.host) USER=\(.user) KEY=\(.key) FILE=\(.file)"')"

KEY_FILE=$(mktemp)
trap 'rm -f "$KEY_FILE"' EXIT
echo "$KEY" > "$KEY_FILE"
chmod 600 "$KEY_FILE"

# 2. Fetch the content via SSH
# -o StrictHostKeyChecking=no: prevents hanging on "yes/no" prompt
CONTENT=$(ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
    -i "$KEY_FILE" \
    "$USER@$HOST" \
    "cat $FILE")

# 3. Return JSON to Terraform
# We use jq to safely encode the string (handling newlines/quotes correctly)
jq -n --arg content "$CONTENT" '{"content":$content}'