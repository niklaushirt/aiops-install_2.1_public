


# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------

## Stuff



### Create Kafkacat
```bash

kubectl apply -n zen -f ./tools/9_kafka_strimzi/kafkacat.yaml 

oc exec -it $(oc get po |grep kafka-cat|awk '{print$1}') bash

```

https://ibm.ent.box.com/s/rid40rx1gyh8k3cxjojltla8mywee7vq

https://github.ibm.com/CASE/zeno-experience

### Adapt S3 Connection on ROKS

```bash
oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/event_group.yaml
oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/event_group_eval.yaml
oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/event_ingest.yaml
oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/log_anomaly.yaml
oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/log_anomaly_eval.yaml
oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/log_ingest.yaml
oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/log_ingest_eval.yaml
```

### Make Flink Console accessible

```bash
oc create route passthrough job-manager --service=demo-ai-manager-ibm-flink-job-manager --port=8000
```

### Install Jupyter Noebook App

```bash
pip3 install jupyterlab

jupyter-lab

pip install notebook
```

        oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k -X DELETE https://localhost:8443/v2/similar_incident_lists"
        oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k -X DELETE https://localhost:8443/v2/alertgroups"
        oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k -X DELETE https://localhost:8443/v2/app_states"

        sleep 20s

        incidents=$(oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k https://localhost:8443/v2/similar_incident_lists")
        alertgroups=$(oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k https://localhost:8443/v2/alertgroups")
        app_states=$(oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k https://localhost:8443/v2/application_groups/$APP_GROUP_ID/app_stat

curl -u $username:$password --insecure -XDELETE https://localhost:9200/<index_name> 
curl -u $ES_USERNAME:$ES_PASSWORD -XGET https://$ES_ENDPOINT/_cat/indices  --insecure 


curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/

curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-sszctxgk-log_models_latest            
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-gj8nhgir-1-pca_fe                     
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-sszctxgk-1-training_count_vectors     
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-sszctxgk-1-embedding_pca_fe           
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-sszctxgk-20210125-logtrain            
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-sszctxgk-event_models_latest          
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-gj8nhgir-log_models_latest            
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-sszctxgk-1-pca_fe                     
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-sszctxgk-1-applications               
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-sszctxgk-20210122-logtrain            
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-gj8nhgir-1-embedding_pca_model        
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-gj8nhgir-20210122-logtrain            
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-sszctxgk-20210123-logtrain            
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-gj8nhgir-1-training_count_vectors     
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-gj8nhgir-20210118-logtrain            
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-sszctxgk-1-embedding_pca_model        
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-sszctxgk-20210120-logtrain            
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-sszctxgk-noi_mapping_models_latest    
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-sszctxgk-1-pca_model                  
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-sszctxgk-pagerduty_mapping_models_late
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-gj8nhgir-20210121-logtrain            
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-gj8nhgir-1-templates                  
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-gj8nhgir-20210115-logtrain            
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-gj8nhgir-1-pca_model                  
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-gj8nhgir-1-embedding_pca_fe           
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/normalized-incidents-3mavyiwf-gj8nhgir         
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-sszctxgk-1-templates                  
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-gj8nhgir-pagerduty_mapping_models_late
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-gj8nhgir-20210120-logtrain            
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-gj8nhgir-1-applications               
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-sszctxgk-20210121-logtrain            
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-gj8nhgir-20210114-logtrain            
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-sszctxgk-20210124-logtrain            
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-gj8nhgir-event_models_latest          
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-sszctxgk-pagerduty_mapping_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-gj8nhgir-pagerduty_mapping_models_latest


curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/normalized-incidents-3mavyiwf-gj8nhgir



alerts-noi-$appgroupid-$appid


alerts-noi-3mavyiwf-gj8nhgir
strimzi-cluster-kafka-bootstrap-zen.tec-cp4aiops-21-3c14aa1ff2da1901bfc7ad8b495c85d9-0000.eu-de.containers.appdomain.cloud



apiVersion: kafka.strimzi.io/v1beta1
kind: KafkaTopic
metadata:
  name: alerts-noi-3mavyiwf-gj8nhgir
  namespace: zen

oc get secret token -n zen --template={{.data.password}} | base64 --decode
oc -n zen create route passthrough strimzi-cluster-kafka-bootstrap --service=strimzi-cluster-kafka-bootstrap --port=tcp-clientstls --insecure-policy=None
oc get routes -n zen strimzi-cluster-kafka-bootstrap -o=jsonpath='{.status.ingress[0].host}{"\n"}'





rm trainingdata/log/$appgroupid/$appid/$version/.DS_Store



python3 -f checker.pyc TEST_LOGS_FILE >results

cp /home/zeno/train/ingest_configs/log/groupid-appid-ingest_conf.json.humio_example /home/zeno/train/ingest_configs/log/ht2luchn-ewspztxo-ingest_conf.json

more /home/zeno/train/ingest_configs/log/ht2luchn-ewspztxo-ingest_conf.json


curl -u $ES_USERNAME:$ES_PASSWORD -XGET https://$ES_ENDPOINT/_cat/indices  --insecure | grep ht2luchn-ewspztxo


oc logs $(oc get po |grep modeltrain-ibm-modeltrain-lcm|awk '{print$1}')

oc logs $(oc get po |grep modeltrain-ibm-modeltrain-trainer|awk '{print$1}')



https://www.ibm.com/support/knowledgecenter/SSQLRP_2.1/train/aiops-train-model-la.html

https://cloud.humio.com/test1nikh/search


curl -k -X PUT https://localhost:9443/v2/connections/application_groups/ht2luchn/applications/ewspztxo/refresh?datasource_type=logs
curl -k -X PUT https://localhost:9443/v2/connections/application_groups/ht2luchn/applications/ewspztxo/refresh?datasource_type=alerts


rm -r /home/zeno/data/trainingdata/
aws s3 rm s3://$LOG_INGEST/ht2luchn/ --recursive

74c4vgcs/omkv3ran

ht2luchn-ewspztxo-ingest_conf.json


oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/log_anomaly.yaml
oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/log_ingest.yaml


aws s3 rm s3://log-anomaly/ --recursive
aws s3 rm s3://log-ingest/ --recursive
aws s3 rm s3://log-model/ --recursive



oc exec -it $(oc get pods | grep aio-controller | awk '{print $1;}') bash



oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- bash

oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k https://localhost:8443/v2/similar_incident_lists" > similar_incident_lists.json
        oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k https://localhost:8443/v2/alertgroups" > alertgroups.json
        oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k https://localhost:8443/v2/application_groups/$APP_GROUP_ID/app_states" > app_sta
tes.json
        oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k https://localhost:8443/v2/stories" > stories.json


oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- bash


delete_connections () {
        echo "I. DELETING CONNECTIONS"
        echo "INFO: All connections for APP_ID '$APP_ID' will be deleted"

        connections_ids=($(oc exec -it $(oc get pods | grep controller | awk '{print $1;}') -- bash -c "curl -k -X GET https://localhost:9443/v2/connections/application_group
s/$APP_GROUP_ID/applications/$APP_ID" | jq '.[].global_id'))

        for connection_id in "${connections_ids[@]}"
        do
                echo "Deleting connection ID: $connection_id"
                deleted_id=$(oc exec -it $(oc get pods | grep controller | awk '{print $1;}') -- bash -c "curl -k -X DELETE https://localhost:9443/v2/cpdconnections/$connecti
on_id")
        done

        connections_ids=$(oc exec -it $(oc get pods | grep controller | awk '{print $1;}') -- bash -c "curl -k -X GET https://localhost:9443/v2/connections/application_groups
/$APP_GROUP_ID/applications/$APP_ID")

        if [ "$connections_ids" == "[]" ]; then
                echo "INFO: Connections for APP_ID '$APP_ID' are deleted"
        else
                echo "WARNING: Connections for APP_ID '$APP_ID' are not deleted ... PLS CHECK !!"
        fi

        echo ""
}

delete_kafka_topics () {
        echo "II. DELETING KAFKA TOPICS"

        declare -a TOPICS=("windowed-logs" "normalized-alerts" "alerts-noi-$APP_GROUP_ID-$APP_ID")

        for topic in "${TOPICS[@]}"
        do
                echo "Deleting Kafka Topic: $topic"
                oc delete kafkatopic $topic
        done

        echo ""
}






clear_db () {
        echo "VII: CLEARING DB (for similar incidents, alert groups, app states)"

        oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k -X DELETE https://localhost:8443/v2/similar_incident_lists"
        oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k -X DELETE https://localhost:8443/v2/alertgroups"
        oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k -X DELETE https://localhost:8443/v2/app_states"

        sleep 20s

        incidents=$(oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k https://localhost:8443/v2/similar_incident_lists")
        alertgroups=$(oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k https://localhost:8443/v2/alertgroups")
        app_states=$(oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k https://localhost:8443/v2/application_groups/$APP_GROUP_ID/app_stat
es")

        sleep 20s

        echo ""

        if [ "$incidents" == "[]" ]; then
                echo "INFO: 'similar_incident_lists' cleared from DB"
        else
                echo "WARNING: 'similar_incident_lists' not cleared from DB ... PLS CHECK !!"
        fi

        if [ "$alertgroups" == "[]" ]; then
                echo "INFO: 'alertgroups' cleared from DB"
        else
                echo "WARNING: 'alertgroups' not cleared from DB ... PLS CHECK !!"
        fi

        if [ "$app_states" == "{}" ]; then
                echo "INFO: 'app_states' cleared from DB"
        else
                echo "WARNING: 'app_states' not cleared from DB ... PLS CHECK !!"
        fi








create_connections () {
        echo "X. CREATE CONNECTIONS"
        echo "INFO: All connections (Live Humio & Kafka NOI) for APP_ID '$APP_ID' will be created"

        # CREATE CONNECTIONS
        export CPOD=`oc get pods | grep controller | awk '{print $1;}'`

        dt=$(date '+%Y-%m-%dT%H:%M:%S')

        # CREATE CONNECTION - Live Humio
        echo "Creating Live Humio connection ..."

        display_name="Humio-$dt"

        oc exec $CPOD -- curl -k -X POST "https://localhost:9443/v2/cpdconnections" -H "Content-Type: application/json" -d "{\"connection_config\": {\"sampling_rate\": 60,\"c
onnection_type\": \"humio\",\"api_key\": \"dVWbjPFb1LsdvZhRUngqAvauf0LY8FSsZcB4XIustx4f\",\"base_parallelism\": 1,\"filters\": \"kubernetes.namespace_name="default"\",\"url\"
: \"http://10.0.0.1:8080/api/v1/repositories/aiops-demo/query\", \"display_name\":\"$display_name\",\"description\":\"\"},\"application_id\": \"$APP_ID\", \"application_group
_id\": \"$APP_GROUP_ID\",\"connection_updated_at\":\"$dt\", \"mapping\": {\"codec\": \"humio\",\"rolling_time\": 10,\"message_field\": \"@rawstring\", \"timestamp_field\": \"
@timestamp\", \"log_entity_types\": \"clusterName, kubernetes.container_image_id, kubernetes.host, kubernetes.container_name, kubernetes.pod_name\", \"instance_id_field\": \"
kubernetes.container_name\"},\"datasource_type\": \"logs\"}"

        # CREATE CONNECTION - Kafka NOI
        echo "Creating Kafka NOI connection ..."

        topic_name="alerts-noi-$APP_GROUP_ID-$APP_ID"

        display_name="NOI-$dt"

        oc exec $CPOD -- curl -k -X POST "https://localhost:9443/v2/cpdconnections" -H "Content-Type: application/json" -d "{\"connection_config\": {\"connection_type\": \"ka
fka\",\"base_parallelism\": 1, \"topic\": \"$topic_name\",\"num_partitions\": 1, \"display_name\":\"$display_name\",\"description\":\"\"},\"application_id\": \"$APP_ID\", \"a
pplication_group_id\": \"$APP_GROUP_ID\",\"connection_updated_at\":\"$dt\", \"mapping\": {\"codec\": \"noi\"},\"datasource_type\": \"alerts\",\"connection_type\": \"kafka\"}"

        # CHECK CONNECTIONS
        connections_ids=$(oc exec -it $(oc get pods | grep controller | awk '{print $1;}') -- bash -c "curl -k -X GET https://localhost:9443/v2/connections/application_groups/$APP_GROUP_ID/applications/$APP_ID")

        if [ "$connections_ids" == "[]" ]; then
                echo "WARNING: connections for APP_ID '$APP_ID' are not created ... PLS CHECK !!"
        else
                echo "INFO: connections for APP_ID '$APP_ID' created"

                connections_ids=($(oc exec -it $(oc get pods | grep controller | awk '{print $1;}') -- bash -c "curl -k -X GET https://localhost:9443/v2/connections/applicati
on_groups/$APP_GROUP_ID/applications/$APP_ID" | jq '.[].global_id'))

                for connection_id in "${connections_ids[@]}"
                do
                        echo "Created connection ID: $connection_id"
                done
        fi

        echo ""
}

echo ""





