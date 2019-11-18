#!/bin/bash
VERISON=1.0
SCRIPT_PATH="$HOME/bin/torrent_scripts"
source "$SCRIPT_PATH"/config.sh
TORRENTLIST=`transmission-remote -n $TR_ADMIN:"$TR_PASSWORD" -l | sed -e '1d;$d;s/^ *//' | cut -s -d " " -f1`
LIMIT_RATIO="100"
SEED_LIMIT_TIME="604800" #equals 7 days
for ID in $TORRENTLIST
do
        RATIO=`transmission-remote -n $TR_ADMIN:"$TR_PASSWORD" --torrent $ID --info  | grep "Ratio:" | cut -s -d ":" -f2`
        echo "ratio = "$RATIO
        if [ $RATIO != "None" ]; then
                INT_RATIO=`echo $RATIO '*100' | bc -l | awk -F '.' '{ print $1; exit; }'`
                echo "converted to interger = " $INT_RATIO
                STATE_STOPPED=`transmission-remote -n $TR_ADMIN:"$TR_PASSWORD" --torrent $ID --info | grep "State: Stopped\|Finished\|Idle\|Seeding"`
                echo "torrent status = "$STATE_STOPPED
                NAME=`transmission-remote -n $TR_ADMIN:"$TR_PASSWORD" --torrent $ID -i | grep "Name:" | cut -s -d ":" -f2`
                echo "torrent name = "$NAME
                SEEDING=`transmission-remote -n $TR_ADMIN:"$TR_PASSWORD" --torrent $ID --info | grep "Seeding Time:" | cut -s -d ":" -f2`
                echo "seed time = "$SEEDING
                PERIOD=`echo $SEEDING | cut -s -d " " -f3`
                PERIOD=${PERIOD#?}
                echo "seed time converted to secs = "$PERIOD
                if [ "$INT_RATIO" -ge "$LIMIT_RATIO" ]; then
                        REASON="Seed Ratio Complete"
                        echo "removing torrent $ID, name=${NAME:1}, reason=$REASON, ratio=$RATIO, seeded time=$SEEDING"
                        . "$SCRIPT_PATH"/rm_torrent.sh "$ID" "$NAME" "$REASON"
                elif [[ $PERIOD -ge $SEED_LIMIT_TIME ]]; then
                        REASON="time limit"
                        echo "removing torrent $ID, name=${NAME:1}, reason=$REASON, ratio=$RATIO, seeded time=$SEEDING"
                        . "$SCRIPT_PATH"/rm_torrent.sh "$ID" "$NAME" "$REASON"
                fi
        fi
done
exit 0
