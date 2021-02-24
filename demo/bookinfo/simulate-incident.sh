echo "Simulating Bookinfo Ratings outage"

echo "${ORANGE}Quit with Ctrl-Z${NC}"

echo "Falco Push"
input="./demo/bookinfo/falco_push.json"
while IFS= read -r line
do
  export my_timestamp=$(date +%s)000
  echo "Injecting Event at: $my_timestamp"

  curl --insecure -X "POST" "$NETCOOL_WEBHOOK_FALCO" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896' \
     -d $"${line}"
  echo "----"
done < "$input"

echo "Done"

echo ""
echo ""
echo ""
echo ""
echo ""
echo "Grafana Push"
input="./demo/bookinfo/grafana_push.json"
while IFS= read -r line
do
  export my_timestamp=$(date +%s)000
  echo "Injecting Event at: $my_timestamp"

  curl --insecure -X "POST" "$NETCOOL_WEBHOOK_GRAFANA" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896' \
     -d $"${line}"
  echo "----"
done < "$input"

echo "Done"

echo ""
echo ""
echo ""
echo ""
echo ""
echo "Git Push"
input="./demo/bookinfo/git_push.json"
while IFS= read -r line
do
  export my_timestamp=$(date +%s)000
  echo "Injecting Event at: $my_timestamp"

  curl --insecure -X "POST" "$NETCOOL_WEBHOOK_GIT" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896' \
     -d $"${line}"
  echo "----"
done < "$input"

echo "Done"

echo ""
echo ""
echo ""
echo ""
echo ""
echo "Injecting Humio Events"

export LOGS_TOPIC=logs-humio-$appgroupid1-$appid1


input="./demo/bookinfo/error_event.json"
while IFS= read -r line
do
  export my_timestamp=$(date +%s)000
  echo "Injecting Event at: $my_timestamp"

  curl --insecure -X "POST" "$NETCOOL_WEBHOOK_HUMIO" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896' \
     -d $"${line}"
  echo "----"
done < "$input"

echo "Done"

echo ""
echo ""
echo ""
echo ""
echo ""
echo "Injecting error Logs"
echo "${ORANGE}Quit with Ctrl-Z${NC}"

export LOGS_TOPIC=logs-humio-$appgroupid1-$appid1

echo "Injecting into Topic $LOGS_TOPIC"

mv ca.crt ca.crt.old
oc extract secret/strimzi-cluster-cluster-ca-cert -n zen --keys=ca.crt

export sasl_password=$(oc get secret token -n zen --template={{.data.password}} | base64 --decode)
export BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -n zen -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443
  
#input="./demo/bookinfo/bookinfo-error-inject.json"
input="./demo/bookinfo/error_log.json"
while IFS= read -r line
do
  export my_timestamp=$(date +%s)000
  echo "Injecting Log line at: $my_timestamp"
  echo ${line} | gsed "s/MY_TIMESTAMP/$my_timestamp/" | kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512  -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -t $LOGS_TOPIC >/dev/null 2>&1
  #kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512  -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -t derived-stories -o end -C -e >/dev/null 2>&1 | grep offset
  echo "----"
done < "$input"

echo "Done"


