# AIOPS AI Manager - LOG ANOMALY TRAINING



# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
## Prepare Datastructure (in the Training Console)
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------

Log in to Training console 

```bash
oc project zen
oc exec -it $(oc get po |grep model-train-console|awk '{print$1}') bash
```

### Create Directory (in training console)

```bash



export appgroupid=zvqubqka
export appid=yqyy711o
export version=1

mkdir -p /home/zeno/data/trainingdata/log/$appgroupid/$appid/$version/
mkdir -p /home/zeno/data/trainingdata/event/$appgroupid/$appid/$version/raw
mkdir -p /home/zeno/data/trainingdata/incident/

```


# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
## Upload Data to Training Console (from Host)
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------

```bash


export appgroupid=zvqubqka
export appid=yqyy711o
export version=1

# Incident
oc cp ./tools/5_training/3_incidents/trainingdata/test-incidents_bookinfo.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/data/trainingdata/incident/test-incidents_bookinfo.json

# Event
oc cp ./tools/5_training/1_events/trainingdata/raw/alerts-noi-bookinfo.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/data/trainingdata/event/$appgroupid/$appid/$version/raw/noi-alerts.json
oc cp ./tools/5_training/1_events/trainingdata/event-noi-alerts_mapping.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/data/trainingdata/event/$appgroupid/$appid/$version/mapping.json
oc cp ./tools/5_training/1_events/trainingdata/event-noi-alerts_mapping.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/train/ingest_configs/event/$appgroupid-$appid-ingest_conf.json

# Logs
oc cp ./tools/5_training/2_logs/trainingdata/raw/log-bookinfo.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/data/trainingdata/log/$appgroupid/$appid/$version/
oc cp ./tools/5_training/2_logs/trainingdata/logs-humio-mapping.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/train/ingest_configs/log/$appgroupid-$appid-ingest_conf.json



```



# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
## Prepare training data (in the Training Console)
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------


### Create Bucket (in training console)

```bash
aws s3 mb s3://$SIMILAR_INCIDENTS
aws s3 mb s3://$EVENT_INGEST
aws s3 mb s3://$LOG_INGEST
```

### Copy Training Data into MinIO (in training console)

```bash
aws s3 sync /home/zeno/data/trainingdata/incident/ s3://$SIMILAR_INCIDENTS/
aws s3 sync /home/zeno/data/trainingdata/event/ s3://$EVENT_INGEST/
aws s3 sync /home/zeno/data/trainingdata/log/ s3://$LOG_INGEST/


```



# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
## Train the model  (in the Training Console)
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------


```bash


export appgroupid=zvqubqka
export appid=yqyy711o
export version=1

# Incident
cd /home/zeno/incident/
cp /home/zeno/train/deploy_model.pyc /home/zeno/train/deploy_model.py
bash index_incidents.sh s3://similar-incident-service/test-incidents_bookinfo.json $appgroupid $appid

# Event
cd /home/zeno/train/
python3 train_pipeline.pyc -p "event" -g "$appgroupid" -a "$appid" -v "$version"

# Logs
cd /home/zeno/train/
python3 train_pipeline.pyc -p "log" -g "$appgroupid" -a "$appid" -v "$version"

```






kubectl get pod -n zen| grep console | awk '{print $1}' | xargs kubectl delete pod -n zen
kubectl get pod -n zen| grep console
oc project zen 
echo "S3 (1/7)"
oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/event_group.yaml
echo "S3 (2/7)"
oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/event_group_eval.yaml
echo "S3 (3/7)"
oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/event_ingest.yaml
echo "S3 (4/7)"
oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/log_anomaly.yaml
echo "S3 (5/7)"
oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/log_anomaly_eval.yaml
echo "S3 (6/7)"
oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/log_ingest.yaml
echo "S3 (7/7)"
oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/log_ingest_eval.yaml
echo "S3 (Done"

cp /home/zeno/train/train_pipeline.py /home/zeno/train/train_pipeline.py-save

# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
## Data Check
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------


Check Number of log lines per container

cat ./tools/5_training/2_logs/trainingdata/raw/log-sockshop.json|jq '.["kubernetes.container_name"]' | sort | uniq -c

Delete istio-proxy entries

grep -v 'kubernetes.container_name":"details' ./tools/5_training/2_logs/trainingdata/raw/log-bookinfo.json > final.json





oc project zen 
oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/event_group.yaml
oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/event_group_eval.yaml
oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/event_ingest.yaml
oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/log_anomaly.yaml
oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/log_anomaly_eval.yaml
oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/log_ingest.yaml
oc exec $(oc get pods -l app.kubernetes.io/component=model-train-console -o jsonpath='{ .items[*].metadata.name }') -- sed -i 's/type: mount_cos/type: s3_datastore/g' /home/zeno/train/manifests/s3fs-pvc/log_ingest_eval.yaml
