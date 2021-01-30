#!/bin/bash
cd /root/firewx

source $(pwd)/config

logger "Emailing morning fire weather briefing."

echo -e "The $title for $(date) has been updated.\n\nRemember to view it at \
$url." | mail -s "$title $(date)" -r "$from" "$email"
