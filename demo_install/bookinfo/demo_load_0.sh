#!/bin/bash


while  : 
do
	echo `/usr/bin/curl -s "http://istio-ingressgateway-istio-system.tec-cp4aiops-xxxx-0000.eu-de.containers.appdomain.cloud/productpage" | /usr/bin/grep -o "<title>.*</title>" `
#sleep 1
done

