#!/bin/bash


echo " "
echo "              ELK Report              "
echo " "

mac=mac.txt
name=name.txt
macsola=macsola.txt
winlogs=winlogs.csv
wifilogs=wifilogs.csv
#sed -n '/Dirección MAC local: /,/ /{p; / /q}' eventssearch.csv
sed -n '/Dirección MAC local: /,/ /{p; / /q}' eventssearch.csv  > $mac

macaddr=`cut -d " " -f4 mac.txt`

sed -n '/SSID de red: /,/ /{p; / /q}' $winlogs > $name

ssid=`cut -d " " -f4 name.txt`

#SSID de red: TFM


echo "1.- Any of these Windows Events: 8000, 11000, 11010, 11001, 11005, 8001, 11004 & 8003 had happened in the machine with MAC Address: $macaddr"

value=$( grep -ic $macaddr $winlogs )
if [ $value -gt 0 ]
then 
	echo "2.- There are evidences that $macaddr has/had wireless activity in the network $ssid"
else
	echo "2.- No evidences that $macaddr has/had a wireless behaviour in the Windows machine"
fi

value1=$( grep -ic $macaddr $wifilogs )
if [ $value1 -gt 0 ]
then 
	echo "3.- $macaddr, as Station MAC, has/had wireless activity in the network $ssid"
else
        echo "3.- $macaddr doesn't appear as Station MAC after Wardriving"

fi

if [ $value -gt 0 ] && [ $value1 -gt 0 ]
then
	echo "*.- SUMMARY: It can affirm 100% that there is a computer in the network (MAC Address $macaddr) which has connected to $ssid. External and internal confirmation"
else
	echo "*.- SUMMARY: It can't ensure 100% that there is a computer in the network which has connected to a wireless connection. Possible False Positive...Check the Logs (according to points 2. and 3.)"
 
fi 

echo "Press any key to continue..."
read foo
clear

echo "Let's go to generate the STIX"

echo "Press any key to continue..."
read foo
clear

sed '16r elkrule.json' template.xml > stix.xml

echo "New STIX successfully generated"

echo "================================"
echo "Press any key to send to SHARING machine"
read foo
sshpass -p "MMM111mmm" scp stix.xml blockubu@192.168.1.123:/home/blockubu/Sharing/

exit 0

