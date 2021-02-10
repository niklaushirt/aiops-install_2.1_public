#!/bin/bash


while  : 
do
	echo `/usr/bin/curl -s "http://istio-ingressgateway-istio-system.waiops-434088-a376efc1170b9b8ace6422196c51e491-0000.us-south.containers.appdomain.cloud/productpage" | /usr/bin/grep -o "<title>.*</title>" `
sleep 1
done

