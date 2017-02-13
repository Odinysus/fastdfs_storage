#!/bin/bash
#set -e

FASTDFS_BASE_PATH="/mnt/storage"
FASTDFS_LOG_FILE="$FASTDFS_BASE_PATH/logs/storaged.log"
NGINX_ERROR_LOG="/usr/local/nginx/logs/error.log"
STORAGE_PID_NUMBER="$FASTDFS_BASE_PATH/data/fdfs_storaged.pid"
STORAGE_LN="/mnt/storage/data/M00"

if [ -f "$FASTDFS_LOG_FILE" ]; then
    rm "$FASTDFS_LOG_FILE"
fi

if [ -f "$NGINX_ERROR_LOG" ]; then
    rm "$NGINX_ERROR_LOG" 
fi

if [ ! -f "$STORAGE_LN" ]; then
    mkdir -p /mnt/storage/data
    ln -s /mnt/storage/data  /mnt/storage/data/M00
fi

echo "start the storage node with nginx.."

fdfs_storaged /etc/fdfs/storage.conf start
/usr/local/nginx/sbin/nginx


TIMES=20
while [ ! -f "$STORAGE_PID_NUMBER" -a $TIMES -gt 0 ]
do 
    sleep 1
        TIMES=`expr $TIMES - 1`
    echo "sleep"
done

# if the storage node start successfully, print the start time
if [ $TIMES -gt 0 ]; then
    echo "storage started successfully at $(date +%Y-%m-%d_%H:%M)"
    echo "please have a look at the log detail at $FASTDFS_LOG_FILE and $NGINX_ERROR_LOG"
    echo 
    echo
    tail -f /usr/local/nginx/logs/error.log -f /usr/local/nginx/logs/access.log -f /mnt/storage/logs/storaged.log
else 
    tail $FASTDFS_LOG_FILE
    echo "==========="
    tail $NGINX_ERROR_LOG
    echo "error at $FASTDFS_LOG_FILE and $NGINX_ERROR_LOG"
fi
