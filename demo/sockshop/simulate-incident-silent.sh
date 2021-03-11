echo "Pushing Sockshop to GitHub"

echo "."
oc scale --replicas=0  deployment catalogue -n sockinfo >/dev/null 2>&1
oc delete pod -n sockinfo $(oc get po -n sockinfo|grep catalogue|awk '{print$1}') --force --grace-period=0 >/dev/null 2>&1
echo "."


sleep 5



if [[ $NETCOOL_WEBHOOK_HUMIO == "not_configured" ]] || [[ $NETCOOL_WEBHOOK_HUMIO == "" ]]
then
      echo ".."
else
      input="./sockshop/error_event.json"
      while IFS= read -r line
      do
        export my_timestamp=$(date +%s)000


        curl --insecure -X "POST" "$NETCOOL_WEBHOOK_HUMIO" \
          -H 'Content-Type: application/json; charset=utf-8' \
          -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896' \
          -d $"${line}" >/dev/null 2>&1
      echo "."
      done < "$input"
fi

echo "Done"



exit 1

echo ""
echo ""
echo ""
echo ""
echo ""
echo "${ORANGE}Quit with Ctrl-Z${NC}"


if [[ $appgroupid1 == "not_configured" ]];
then
    echo "Skipping Log Anomaly injection"
else
    echo "Injecting error Logs"
    echo "${ORANGE}Quit with Ctrl-Z${NC}"

    export LOGS_TOPIC=logs-humio-$appgroupid1-$appid1

    echo "Injecting into Topic $LOGS_TOPIC"

    mv ca.crt ca.crt.old
    oc extract secret/strimzi-cluster-cluster-ca-cert -n zen --keys=ca.crt

    export sasl_password=$(oc get secret token -n zen --template={{.data.password}} | base64 --decode)
    export BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -n zen -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443
      
    #input="./sockshop/sockshop-error-inject.json"
    input="./sockshop/error_log.json"
    while IFS= read -r line
    do
      export my_timestamp=$(date +%s)000
      echo "Injecting Log line at: $my_timestamp"
      echo ${line} | gsed "s/MY_TIMESTAMP/$my_timestamp/" | kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512  -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -t $LOGS_TOPIC >/dev/null 2>&1
      kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512  -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -t derived-stories -o end -C -e >/dev/null 2>&1 | grep offset
      echo "----"
    done < "$input"

      echo "Done"
      echo ""
      echo ""
      echo ""
      echo ""
      echo ""

fi


echo "Done"

