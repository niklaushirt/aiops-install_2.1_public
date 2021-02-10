#!/bin/bash


while  : 
do
	echo `/usr/bin/curl -s "http://kubetoy-kubetoy.apps.ocp45.tec.uk.ibm.com/logit?msg=ping" | /usr/bin/grep -o "Found" `
	echo `/usr/bin/curl -s "http://kubetoy-kubetoy.apps.ocp45.tec.uk.ibm.com/logit?msg=I%27m%20still%20there%0A" | /usr/bin/grep -o "Found" `
	echo `/usr/bin/curl -s "http://kubetoy-kubetoy.apps.ocp45.tec.uk.ibm.com/logit?msg=All%20is%20good" | /usr/bin/grep -o "Found" `
	echo `/usr/bin/curl -s "http://kubetoy-kubetoy.apps.ocp45.tec.uk.ibm.com/logit?msg=Feeling%20good%20today" | /usr/bin/grep -o "Found" `



	echo `/usr/bin/curl -X POST -s "http://kubetoy-kubetoy.apps.ocp45.tec.uk.ibm.com/health" | /usr/bin/grep -o "Redirecting" `
	sleep 15



done

