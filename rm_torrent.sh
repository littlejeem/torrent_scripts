#!/bin/bash
transmission-remote -n "$TR_ADMIN":"$TR_PASSWORD" --torrent $ID --remove-and-delete | cut -d "\"" -f2
touch "$HOME"/bin/torrent_scripts/rm_torrent.log
echo "$(date) - DELETED - Reason:$3 - TorrentID:$1 - Name:$2" >> "$HOME"/bin/torrent_scripts/rm_torrent.log
