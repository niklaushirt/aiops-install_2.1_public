echo "Pushing Bookinfo to GitHub"

oc login --token=eyJhbGciOiJSUzI1NiIsImtpZCI6IkxzdUQ1MHU3TVI0SzJsSEZ3U1hEYzlsMW81dVlQRjg1Q1YyNDd4ek14RVEifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJ6ZW4iLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlY3JldC5uYW1lIjoiZGVtby1hZG1pbi10b2tlbi14OXdzZyIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJkZW1vLWFkbWluIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiMzQzZWJkZTItNzQwNy00NjE2LTlkMzgtMmY4N2JkZGI4MTQ4Iiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50OnplbjpkZW1vLWFkbWluIn0.qlaSTod21LI3POXjC5JLu--OxCZpDRqQPVTBi3NO53Ezljsev34XcWrSUGlxyuc6k_N3LiUUv1kUKTh8-njPynkKQvCZxIc-EukgFSyUT-o_6GFPjpC_IayB3GlnaPkzcPU07VIKo0cQCh0_9yiFNUVxytFKW7FaaOR-ghirt-QRg9XbYhCBbAsmC-nWZ_Cu7X3mAFLyie58RIeUaAGKsTwDML_QU3sKQt3KzB8GY45Fz8sjltVM-Dfaq8O0mNYxABNGwBHFiGVM0MxC__JV4TIr_xOSM8c2rm0u3a59YF_XhcIgBPW8nfRuKygARUxO5t248Iv5nlZSMCqCJk1A-Q --server=https://c114-e.us-south.containers.cloud.ibm.com:30721 >/dev/null 2>&1
echo "."
oc scale --replicas=0  deployment ratings-v1 -n bookinfo >/dev/null 2>&1
echo "."

input="./demo/bookinfo/falco_push.json"
while IFS= read -r line
do
  export my_timestamp=$(date +%s)000
 
  curl --insecure -X "POST" "$NETCOOL_WEBHOOK_FALCO" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896' \
     -d $"${line}" >/dev/null 2>&1
echo "."
done < "$input"


input="./demo/bookinfo/grafana_push.json"
while IFS= read -r line
do
  export my_timestamp=$(date +%s)000


  curl --insecure -X "POST" "$NETCOOL_WEBHOOK_GRAFANA" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896' \
     -d $"${line}" >/dev/null 2>&1
echo "."
done < "$input"


input="./demo/bookinfo/git_push.json"
while IFS= read -r line
do
  export my_timestamp=$(date +%s)000


  curl --insecure -X "POST" "$NETCOOL_WEBHOOK_GIT" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896' \
     -d $"${line}" >/dev/null 2>&1
echo "."
done < "$input"



export LOGS_TOPIC=logs-humio-$appgroupid1-$appid1


input="./demo/bookinfo/error_event.json"
while IFS= read -r line
do
  export my_timestamp=$(date +%s)000


  curl --insecure -X "POST" "$NETCOOL_WEBHOOK_HUMIO" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896' \
     -d $"${line}" >/dev/null 2>&1
echo "."
done < "$input"

echo "Done"

exit 1

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


