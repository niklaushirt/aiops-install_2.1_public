#!/bin/bash


while  : 
do
	echo `/usr/bin/curl -s "http://sock-sock-shop.tec-cp4aiops-xxxx-0000.eu-de.containers.appdomain.cloud/index.html" | /usr/bin/grep -o "mammoths" `
sleep 1
done

