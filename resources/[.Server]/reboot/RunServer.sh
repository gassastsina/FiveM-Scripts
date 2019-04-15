#!/bin/bash

#script
echo `date '+%d-%B-%Y_%H:%M:%S'`" - Launching server..."
cd /home/fxserver/server-data
bash /home/fxserver/run.sh +exec server.cfg >> /home/fxserver/logs/`date '+%d-%B-%Y_%H:%M:%S'`.log