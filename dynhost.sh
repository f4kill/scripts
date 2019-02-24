#/bin/sh
 
#
# CONFIG
#
 
HOSTS=( first.host.name second.host.name )
LOGIN=login
PASSWORD=password
 
PATH_LOG=/var/log/dynhost
 
#
# ----
#

CURRENT_IP=`curl -4 ifconfig.co`

echo > $PATH_LOG
echo -n "Run dyndns " >> $PATH_LOG
date >> $PATH_LOG
 
echo -n "Current IP " >> $PATH_LOG
echo "$CURRENT_IP" >> $PATH_LOG
for i in "${HOSTS[@]}"
do
   : 
	HOST_IP=`dig +short $i`

	echo -n "[$i] IP: " >> $PATH_LOG
	echo "$HOST_IP" >> $PATH_LOG
	 
	#
	# DO THE WORK
	#
	if [ -z $CURRENT_IP ] || [ -z $HOST_IP ]
	then
	        echo "[$i] No IP retrieved" >> $PATH_LOG
	else
	        if [ "$HOST_IP" != "$CURRENT_IP" ]
	        then
	                echo "[$i] IP has changed" >> $PATH_LOG
	                RES=`curl --user "$LOGIN:$PASSWORD" "https://www.ovh.com/nic/update?system=dyndns&hostname=$i&myip=$CURRENT_IP"`
	                echo -n "[$i] Request result : " >> $PATH_LOG
	                echo "$RES" >> $PATH_LOG
	        else
	                echo "[$i] IP has not changed" >> $PATH_LOG
	        fi
	fi
done
