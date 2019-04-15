# AutomaticLinuxReboot
show how to reboot your server each ... hours or days. This alos creates log files of your rebooted server.

#Attention: les syntaxes utilisées sont compatibles Debian 8, je n'ai pas tester sous d'autres distributions Linux.


# Requirements
- crontab: 
```bash
sudo apt-get update
sudo apt-get install cron
```

# Script
```bash
#!/bin/bash
echo "***********************************************************"
echo `date '+%d-%B-%Y_%H:%M:%S'` " - Starting procedure..."
sleep 2
echo `date '+%d-%B-%Y_%H:%M:%S'` " - Stopping server..."
pkill screen
sleep 10
echo `date '+%d-%B-%Y_%H:%M:%S'`" - Restart mysql service..."
sudo service mysql restart
sleep 10
echo `date '+%d-%B-%Y_%H:%M:%S'` " - Emptying cache..."
rm -R /home/FxServer/fx-server-data/cache
sleep 5
echo `date '+%d-%B-%Y_%H:%M:%S'` " - Starting server..."
screen -L ServerLog/`date '+%Y-%m-%d_%H:%M:%S'` -d -m bash /root/RunServer.sh

sleep 15
echo `date '+%d-%B-%Y_%H:%M:%S'` " - End procedure"

```
# Note
Put the RunServer.sh and CheckCrashServer.sh file in user folder

Change into reload_fxserver.sh:
- /home/FxServer/fx-server-data/cache  --> your directory of cache
- /root/RunServer.sh --> YOURVPSUSER/RunServer.sh

Change into RunFxServer.sh:
- FXSERVERDATA --> your server data folder
- FXSERVER --> server folfer

Change into CheckCrashServer.sh:
- HOST --> your server ip
- PORT --> your fivem server port
- /home/FxServer/reload_fxserver.sh --> location where reload_fxserver.sh is located

Set the folder into your resource folder if you want to warn your server when it's going to reboot.
Just edit the timing and texts to your liking

the server will launch in a screen to open the screen while it is rebooted go to terminal and type: 'screen -r'

# Adding automatic reboot
To access cromtab enter following command while being in root: 'crontab -e'

*This example server will reboot at midday (12h01) and midnight(00h01) and checks if server cashs every minute*

/!\ DO NOT DO less then 1 min otherwise you will start twice your server /!\ 

```bash
*/2 * * * * bash /root/CheckCrashServer.sh >> /var/log/fxreload/fxreloadlog
01 12 * * * bash /home/FxServer/reload_fxserver.sh >> /var/log/fxreload/fxreloadlog
01 00 * * * bash /home/FxServer/reload_fxserver.sh >> /var/log/fxreload/fxreloadlog
```

*To see if crontab is registred:* 'crontab -l'

# create log files
While being in root entrer following commands:.
```
mkdir /var/log/fxreload
chown -R root:root /var/log/fxreload/        (change root to your computer user)
```
```
mkdir ServerLog
```

Copy and paste fxreload into /etc/logrotate.d/  directory

*To verify you installed it correclty enter command: 'cat /etc/logrotate.d/fxreload'*

# To see your log files:
```
cat /var/log/fxreload/fxreloadlog     --> for reboot logs
```
Go to the folder /USERNAME/ServerLog  in that folder you will have all logs of your server  (change USERNAME to username of your computer)

# Conclusion
Now your server will start each day at midday and midnight with log files


# thanks to: 
Tracid  (https://github.com/tracid56) for original script
