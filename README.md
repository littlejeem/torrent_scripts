### Introduction ###
A set of scripts to take the administration out of seeding through transmission.

Torrents will be removed if they hit the desired seeding time limit or ratio

### Details ####
This set of scripts exists on the download machine with transmission-daemon and transmission-cli installed on it. Setting up a folder such as ```/home/$USER/bin/torrent_scripts``` is advised.

Configuration is completed by editing variables in config.sh

### Installation ###
Create a directory for the scripts to go into, eg
mkdir ```/home/$USER/bin/torrent_scripts```
where $USER is your user running transmission-daemon

Now the script can be run manually (not a bad idea when testing) but for automation add it as a cron job

```crontab -e```

and add following line to run scripts at 9 every day

```* 9 * * * /home/$USER/bin/torrent_scripts/rm_seeded_torrent.sh```

### Configuration ###
There are four variables that need completing in config.sh

```TR_ADMIN="put your transmission username here"```
```TR_PASSWORD="put your transmission password here"```
```LIMIT_RATIO="" #100 equals 1:1 ratio, 200=2:1 etc etc```
```SEED_LIMIT_TIME="604800" #seed time in seconds, default is 7days```
