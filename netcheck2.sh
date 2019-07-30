#!/bin/bash
########################################################################
dest_ip=1.1.1.1
path_log=~/ping.log
NOW1=$(date +"%T | %d-%m-%Y")
timeout_dead=60
timeout_live=5
COUNTER=0
drop=0
drop_max=10
########################################################################
echo ================================================
echo "[*] Program started at $NOW1"
echo [*] LOGGING SAVED IN $path_log
echo [*] Size of logg file is $(ls -l --b=M  $path_log | cut -d " " -f5)
echo [*] Timeout of Live Ping is $timeout_live Seconds and Death Ping $timeout_dead Seconds
echo [*] Maximum of droped packets is $drop_max
echo ================================================
echo ================================================ >> $path_log 
echo [*] Program started at $NOW1 >> $path_log 
echo [*] LOGGING SAVED IN $path_log >> $path_log
echo ================================================ >> $path_log 
while [ 1 ]; do
NOW=$(date +"%T | %d-%m-%Y")
sleep $timeout_live
ping -c 1 $dest_ip 1>> ~/ping_output.log
result=$?
if [ $result == "1" ]; then
	if (($drop == $drop_max )); then
		echo [-] FAIL on $NOW to $ip starting traceroute
		echo [-] FAIL on $NOW  Doing tracert! to $ip >> $path_log 
		echo -----------------------TRACEROUTE------------------------------ >> $path_log 
		traceroute $ip >> $path_log 
		echo -------------------END TRACEROUTE------------------------------ >> $path_log 
		echo [!] WAITING $timeout_dead Second before next check
		echo [!] Check output log for more details where route end
		echo [!] WAITING $timeout_dead Second before next check >> $path_log 
		COUNTER=$[$COUNTER +1]
		echo [!] $COUNTER retries per $COUNTER Minutes.
		echo [!] $COUNTER retries per $COUNTER Minutes. >> $path_log 
		sleep $timeout_dead
		else
		drop=$[$drop+1]
		echo [!] Dropped $drop of $drop_max packets
		echo [!] Dropped $drop of $drop_max packets >> $path_log
		fi
fi

if [ $result == "0" ]; then
echo [+] SUCCEED on $NOW to $ip >> $path_log 
echo [+] SUCCEED on $NOW to $ip 
fi
done
