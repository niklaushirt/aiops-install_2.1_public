

# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# DEBUG 
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------


```bash
oc logs -f $(oc get pod |grep chatops-slack-integrator | awk '{print $1}') | less
```

## restart flink jobs
```bash
oc exec $(oc get pod -n zen |grep controller | awk '{print $1}') -n zen -- /usr/bin/curl -k -X PUT https://localhost:9443/v2/connections/application_groups/1rsoloaz/applications/xeii8qo2/refresh?datasource_type=logs
oc exec $(oc get pod -n zen |grep controller | awk '{print $1}') -n zen -- /usr/bin/curl -k -X PUT https://localhost:9443/v2/connections/application_groups/1rsoloaz/applications/xeii8qo2/refresh?datasource_type=alerts
```



## Kafka

## Topics

```bash

oc get kafkatopic -n zen

export sasl_password=$(oc get secret token -n zen --template={{.data.password}} | base64 --decode)
export BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -n zen -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443

echo "export BROKER=$BROKER"
echo "export sasl_password=$sasl_password"


```

```bash

kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./kafkacat-ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -o beginning -C -t alerts-noi-3mavyiwf-gj8nhgir     
kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./kafkacat-ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -o beginning -C -t normalized-alerts-3mavyiwf-gj8nhgir                       
kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./kafkacat-ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -o beginning -C -t windowed-logs-3mavyiwf-gj8nhgir 



kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./kafkacat-ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -o beginning -C -t alerts-noi-3mavyiwf-sszctxgk     
kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./kafkacat-ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -o beginning -C -t normalized-alerts-3mavyiwf-sszctxgk                       
kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./kafkacat-ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -o beginning -C -t windowed-logs-3mavyiwf-sszctxgk   


kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./kafkacat-ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -o beginning -C -t derived-stories   




kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./kafkacat-ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -o beginning -C -t applications                                                
kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./kafkacat-ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -o beginning -C -t connections       

kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./kafkacat-ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -o beginning -C -t raw-user-actions                                            
kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./kafkacat-ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -o beginning -C -t raw-user-messages  


```


## Indices

```bash



curl -u $ES_USERNAME:$ES_PASSWORD -XGET https://$ES_ENDPOINT/_cat/indices  --insecure 

oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k https://localhost:8443/v2/similar_incident_lists" 
oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k https://localhost:8443/v2/alertgroups" 
oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k https://localhost:8443/v2/application_groups/$APP_GROUP_ID/app_states" 
oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k https://localhost:8443/v2/stories" 

oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k https://localhost:8443/_cat/indices" 

elasticsearch-ibm-elasticsearch-ibm-elasticsearch-srv.zen.svc.cluster.local:443

```


oc get pods -n zeno | grep "Terminating" | awk '{print $1}' | xargs oc delete pod -n zeno  --force --grace-period=0

oc get pods -n noioper | grep "Terminating" | awk '{print $1}' | xargs oc delete pod -n noioper --force --grace-period=0