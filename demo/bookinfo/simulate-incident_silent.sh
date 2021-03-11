echo "Pushing Bookinfo to GitHub"

echo "."
oc scale --replicas=0  deployment ratings-v1 -n bookinfo >/dev/null 2>&1
oc delete pod -n bookinfo $(oc get po -n bookinfo|grep ratings-v1|awk '{print$1}') --force --grace-period=0 >/dev/null 2>&1
echo "."


sleep 5



if [[ $NETCOOL_WEBHOOK_GIT == "not_configured" ]] || [[ $NETCOOL_WEBHOOK_GIT == "" ]]
then
      echo ".."
else
      input="./bookinfo/git_push.json"
      while IFS= read -r line
      do
        export my_timestamp=$(date +%s)000


        curl --insecure -X "POST" "$NETCOOL_WEBHOOK_GIT" \
          -H 'Content-Type: application/json; charset=utf-8' \
          -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896' \
          -d $"${line}" >/dev/null 2>&1
      echo "."
      done < "$input"
      sleep 2
fi




if [[ $NETCOOL_WEBHOOK_FALCO == "not_configured" ]] || [[ $NETCOOL_WEBHOOK_FALCO == "" ]]
then
      echo ".."
else
      input="./bookinfo/falco_push.json"
      while IFS= read -r line
      do
        export my_timestamp=$(date +%s)000
      
        curl --insecure -X "POST" "$NETCOOL_WEBHOOK_FALCO" \
          -H 'Content-Type: application/json; charset=utf-8' \
          -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896' \
          -d $"${line}" >/dev/null 2>&1
      echo "."
      done < "$input"
      sleep 2
fi 




if [[ $NETCOOL_WEBHOOK_METRICS == "not_configured" ]] || [[ $NETCOOL_WEBHOOK_METRICS == "" ]]
then
      echo ".."
else
      input="./bookinfo/metrics_push.json"
      while IFS= read -r line
      do
        export my_timestamp=$(date +%s)000


        curl --insecure -X "POST" "$NETCOOL_WEBHOOK_METRICS" \
          -H 'Content-Type: application/json; charset=utf-8' \
          -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896' \
          -d $"${line}" >/dev/null 2>&1
      echo "."
      done < "$input"
      sleep 2
fi 



if [[ $NETCOOL_WEBHOOK_INSTANA == "not_configured" ]] || [[ $NETCOOL_WEBHOOK_INSTANA == "" ]]
then
      echo ".."
else
      input="./bookinfo/instana_push.json"
      while IFS= read -r line
      do
        export my_timestamp=$(date +%s)000
      
        curl --insecure -X "POST" "$NETCOOL_WEBHOOK_INSTANA" \
          -H 'Content-Type: application/json; charset=utf-8' \
          -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896' \
          -d $"${line}" >/dev/null 2>&1
      echo "."
      done < "$input"
      sleep 2
fi 



if [[ $NETCOOL_WEBHOOK_HUMIO == "not_configured" ]] || [[ $NETCOOL_WEBHOOK_HUMIO == "" ]]
then
      echo ".."
else
      input="./bookinfo/error_event.json"
      while IFS= read -r line
      do
        export my_timestamp=$(date +%s)000


        curl --insecure -X "POST" "$NETCOOL_WEBHOOK_HUMIO" \
          -H 'Content-Type: application/json; charset=utf-8' \
          -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896' \
          -d $"${line}" >/dev/null 2>&1
      echo "."
      done < "$input"
      sleep 2
fi

echo "---"


if [[ $appgroupid1 == "not_configured" ]];
then
    echo "Skipping Log Anomaly injection"
else

    export LOGS_TOPIC=logs-humio-$appgroupid1-$appid1

    #echo "Injecting into Topic $LOGS_TOPIC"

    mv ca.crt ca.crt.old  >/dev/null 2>&1
    echo "."
    oc extract secret/strimzi-cluster-cluster-ca-cert -n zen --keys=ca.crt >/dev/null 2>&1
    echo "."

    export sasl_password=$(oc get secret token -n zen --template={{.data.password}} | base64 --decode)
    export BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -n zen -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443
      
    #input="./bookinfo/bookinfo-error-inject.json"
    input="./bookinfo/error_log.json"
    while IFS= read -r line
    do
      export my_timestamp=$(date +%s)000
      echo ${line} | gsed "s/MY_TIMESTAMP/$my_timestamp/" | kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512  -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -t $LOGS_TOPIC >/dev/null 2>&1
      echo ".."
    done < "$input"

fi


echo "Done"

