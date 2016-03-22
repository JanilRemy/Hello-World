#! /bin/bash
let i=0
let b=2
compInstA="plow"
managInterA="plow"
alarmA="plow"
compInstN="plow"
managInterN="plow"
notN="plow"
while true
do
u=$(($RANDOM %7)) #Value 0,1,2,3,4,5,7 for notification2 and alarm
((i++))
let x=0+i # counter
z=$(echo "scale=4; $x/$b" | bc) # counter divided by 2 for alarm set
y=$(($RANDOM % 200)) # value for line anh help with the status raised or cleared
# switch case for values of the measurment notification2 and alarm
case $u in 
	0)
	compInstN="copy_clone"
        managInterN="copy"
        notN="received" 
	compInstA="copy_clone"
        managInterA="copy"
        alarmA="copy_alarm1" 
        ;;
	1)
	compInstN="copy_shm1"
        managInterN="copy" 
        notN="send" 
	compInstA="copy_shm1"
        managInterA="copy" 
        alarmA="copy_alarm2@in2_0" 
        ;;
	2)
	compInstN="copy_shm2"
        managInterN="copy"  
        notN="received" 
	compInstA="copy_shm2"
        managInterA="copy"  
        alarmA="copy_alarm2@in2_1" 
        ;;
	3)
	compInstN="copy_tcp"
        managInterN="copy"  
        notN="received" 
	compInstA="copy_tcp"
        managInterA="copy"  
        alarmA="copy_alarm2@in2_0" 
        ;;
	4)
	compInstN="copy_udp"
        managInterN="copy"
        notN="send"
	compInstA="copy_udp"
        managInterA="copy"
        alarmA="copy_alarm2@udp"
        ;;
	5)
 	compInstN="receive_data"
        managInterN="receive"
        notN="received"
	compInstA="send_data"
        managInterA="send" 
        alarmA="send_alarm" 
	;;
	6)
	compInstA="send_data"
        managInterA="send" 
        alarmA="send_alarm" 
	compInstN="send_data"
        managInterN="send" 
        notN="send_notif" 
        ;;
	*)
esac

if [ $y -gt 100 ]
then
status="raised"
else
status="cleared"
fi
# send data to the measurement notification2 in the database o2 
curl -i -XPOST 'http://localhost:8086/write?db=o2' --data-binary 'notification2,configuration\ Location="coverage",component\ Instance='\"$compInstN\"',management\ Interface='\"$managInterN\"',notification='\"$notN\"',source\ Code="src/c/copy_component.c",line='$y' counter='$x''
# send data to the measurement alarm in the database o2
curl -i -XPOST 'http://localhost:8086/write?db=o2' --data-binary 'alarm,configuration\ Location="coverage",component\ Instance='\"$compInstA\"',management\ Interface='\"$managInterA\"',status='\"$status\"',alarm='\"$alarmA\"',set='$z' reset='$x''
sleep 5
done

