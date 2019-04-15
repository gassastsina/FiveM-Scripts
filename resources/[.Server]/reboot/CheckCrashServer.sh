#!/bin/bash

#config
HOST=217.182.175.18
PORT=30120

#script
# timeout 2 bash -c "</dev/tcp/$HOST/$PORT";

(exec 3<>/dev/tcp/$HOST/$PORT) &>/dev/null

if [ $? -ne 0 ];
then
    echo `date '+%d-%B-%Y_%H:%M:%S'` " - Detected server crash !"
	echo "launching server again :"
	screen -x fxserver -X stuff " bash /home/fxserver/server-data/resources/[.LSNights]/reboot/RunServer.sh
	"
# else 
	# echo `date '+%d-%B-%Y_%H:%M:%S'` " - Server on!"
fi

