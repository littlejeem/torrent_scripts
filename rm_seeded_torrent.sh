#!/bin/bash
#
#
##############################
### set & import variables ###
##############################
SCRIPT_PATH="/home/pi/bin/torrentscripts"
source "$SCRIPT_PATH"/config.sh
TORRENTLIST=`transmission-remote -n "$TR_ADMIN":"$TR_PASSWORD" -l | sed -e '1d;$d;s/^ *//' | cut -s -d " " -f1`
#
#
####################
### begin script ###
####################
for ID in "$TORRENTLIST"
do
  RATIO=`transmission-remote -n "$TR_ADMIN":"$TR_PASSWORD" --torrent "$ID" --info  | grep "Ratio:" | cut -s -d ":" -f2`
  echo "$RATIO"
    if [ $RATIO != "None" ];
    then
      INT_RATIO=`echo $RATIO '*100' | bc -l | awk -F '.' '{ print $1; exit; }'`
		  echo "$INT_RATIO"
      STATE_STOPPED=`transmission-remote -n "$TR_ADMIN":"$TR_PASSWORD" --torrent $ID --info | grep "State: Stopped\|Finished\|Idle\|Seeding"`
		  echo "$STATE_STOPPED"
      NAME=`transmission-remote -n "$TR_ADMIN":"$TR_PASSWORD" --torrent $ID -i | grep "Name:" | cut -s -d ":" -f2`
      echo "$NAME"
		  SEEDING=`transmission-remote -n "$TR_ADMIN":"$TR_PASSWORD" --torrent $ID --info | grep "Seeding Time:" | cut -s -d ":" -f2`
      echo "$SEEDING"
		  PERIOD=`echo $SEEDING | cut -s -d " " -f3`
      echo "$PERIOD"
		  PERIOD=${PERIOD#?}
		  echo $PERIOD
        if [ "$INT_RATIO" -ge "$LIMIT_RATIO" ];
        then
          #logger -p $LOG_FILE -t $LOG_APP "removing torrent $ID, name=${NAME:1}, ratio=$RATIO"
			    REASON="1:1 Seed Complete"
			    echo "removing torrent $ID, name=${NAME:1}, reason=$REASON, ratio=$RATIO, seeded time=$SEEDING"
          . "$SCRIPT_PATH"/rm_torrent.sh "$ID" "$NAME" "$REASON"
            elif [[ "$PERIOD" -ge "$SEED_LIMIT_TIME" ]];
            then
			        REASON="time limit"
			        echo "removing torrent $ID, name=${NAME:1}, reason=$REASON, ratio=$RATIO, seeded time=$SEEDING"
              . "$SCRIPT_PATH"/rm_torrent.sh "$ID" "$NAME" "$REASON"
            fi
        fi
done
exit 0
