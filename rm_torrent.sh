#!/bin/bash
source /home/pi/bin/torrentscripts/my_password.sh
transmission-remote -n $TR_ADMIN:"$TR_PASSWORD" --torrent $ID --remove-and-delete | cut -d "\"" -f2
touch /home/pi/bin/torrentscripts/test.log
echo "$(date) - DELETED - Reason:$3 - TorrentID:$1 - Name:$2" >> /home/pi/bin/torrentscripts/test.log
