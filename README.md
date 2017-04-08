##################
# torrentscripts #
##################
#
# 
###################################################################################
# A set of scripts to take the administration out of seeding through transmission #
# torrents will be removed if they hit the desired seeding time limit or ratio    #
###################################################################################
#
# this set of scripts exists on the download machine with transmission-daemon and transmission-cli installed on it
# e.g. folder such as /home/pi/bin/transmissionscripts
# for the sake of privacy I can't upload one file needed so you will need to create a file in the same path as the
# rest of the scripts called my_password.sh
# dont forget to chmod +x so it is executable
# edit the file so that it contains two variables
# TR_ADMIN="put your transmission username here"
# TR_PASSWORD="put your transmission password here"
# Now.........the script can be run manually (not a bad idea when testing) but for automation add it as a cron job
# e.g. crontab -e and add following line to run scripts at 9 every day
# * 9 * * * /home/pi/bin/torrentscripts/rm_seeded_torrent.sh
#
# in the main script rm_seeded_torrent.sh there are two way to delete torrents,
# 1: they've reached the ratio goal (e.g 1:1) or
# 2: they've been active for the desired seeding time
# these varibles are set using
# LIMIT_RATIO="100" #1:1, 200 would equal 2:1
# and
# SEED_LIMIT_TIME="604800" #this variable is in seconds, eg: 604800 is 7 days seeding
# alter these to your preference
######################################################################################################################
