#!/bin/bash
########################################################################
dest_ip=1.1.1.1 #enter your IP which you want to ping
dir_date=$(date +"%d-%m-%Y")
dir=logs/$dir_date
path_log=$dir/ping.log #enter your path for log file
ping_output=$dir/ping_output.log #enter your path for ping output log file

NOW1=$(date +"%T | %d-%m-%Y") #current date in format 24H Time | D-M-Y

timeout_dead=60 #how many seconds wait before next check if connection is unreachable
timeout_live=5 #how many seconds wait before next chcek if connection is live
COUNTER=0 #counting retries per timeout_dead seconds
drop=0 #drop counter
drop_max=10 #set max drop counter which will trigger traceroute
########################################################################
if [ ! -d "$dir" ]; then
  mkdir -p $dir
fi
########################################################################
echo ================================================ >> $path_log 
echo [*] Program started at $NOW1 >> $path_log 
echo [*] LOGGING SAVED IN $path_log >> $path_log
echo ================================================ >> $path_log 
########################################################################
echo ================================================
echo [*] Program started at $NOW
echo [*] LOGGING SAVED IN $path_log
echo [*] Size of logg file is $(ls -l --b=M  $path_log | cut -d " " -f5)
echo [*] Timeout of Live Ping is $timeout_live Seconds and Death Ping $timeout_dead Seconds
echo [*] Maximum of droped packets is $drop_max
echo [*] Ping target is $dest_ip
echo ================================================
########################################################################
while [ 1 ]; do
NOW=$(date +"%T | %d-%m-%Y")
sleep $timeout_live
ping -c 1 $dest_ip 1>> $ping_output
result=$?
if [ $result == "1" ]; then
	if (($drop == $drop_max )); then
		echo [-] FAIL on $NOW to $dest_ip starting traceroute
		echo [-] FAIL on $NOW  Doing tracert! to $dest_ip >> $path_log 
		echo -----------------------TRACEROUTE------------------------------ >> $path_log 
		traceroute $dest_ip >> $path_log 
		echo -------------------END TRACEROUTE------------------------------ >> $path_log 
		echo [!] WAITING $timeout_dead Second before next check
		echo [!] Check output log for more details where route end
		echo [!] WAITING $timeout_dead Second before next check >> $path_log 
		COUNTER=$[$COUNTER +1]
		echo [!] $COUNTER retries per $COUNTER Seconds.
		echo [!] $COUNTER retries per $COUNTER Seconds. >> $path_log 
		sleep $timeout_dead
		else
		drop=$[$drop+1]
		echo [!] Dropped $drop of $drop_max packets
		echo [!] Dropped $drop of $drop_max packets >> $path_log
	fi
fi
########################################################################
if [ $result == "0" ]; then
echo [+] SUCCEED on $NOW to $dest_ip >> $path_log 
echo [+] SUCCEED on $NOW to $dest_ip
drop=0 # reset droped packets counter
fi
done
