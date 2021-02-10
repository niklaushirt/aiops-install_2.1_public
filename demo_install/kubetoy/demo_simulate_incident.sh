#!/bin/bash


while  : 
do
	export sasl_password=$(oc get secret token -n zen --template={{.data.password}} | base64 --decode)
	export BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443


	kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./kafkacat-ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -P -t alerts-noi-3mavyiwf-sszctxgk -l ./demo/kubetoy/kubetoy-test-crash.json

	kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./kafkacat-ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -P -t alerts-noi-3mavyiwf-sszctxgk -l ./demo/kubetoy/kubetoy-test-demo.json

	
done

