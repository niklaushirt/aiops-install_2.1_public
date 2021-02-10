#!/bin/bash


while  : 
do
	echo `/usr/bin/curl -X POST -s "http://kubetoy-kubetoy.tec-cp4aiops-3c14aa1ff2da1901bfc7ad8b495c85d9-0000.eu-de.containers.appdomain.cloud/crash" | /usr/bin/grep -o "RIP" `
	sleep 1
	oc get pods -n kubetoy | grep "kubetoy-deployment" | awk '{print $1}' | xargs oc delete pod -n kubetoy  --force --grace-period=0
	sleep 10
done

