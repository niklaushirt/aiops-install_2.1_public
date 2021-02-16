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


# Sockshop
export appgroupid=k8muiz8w
export appid=emjei3wm
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

# Sockshop
export appgroupid=k8muiz8w
export appid=emjei3wm
export version=1

# Incident
oc cp ./tools/5_training/3_incidents/trainingdata/test-incidents_sockshop.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/data/trainingdata/incident/test-incidents_sockshop.json

# Event
oc cp ./tools/5_training/1_events/trainingdata/raw/alerts-noi-sockshop.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/data/trainingdata/event/$appgroupid/$appid/$version/raw/noi-alerts.json
oc cp ./tools/5_training/1_events/trainingdata/event-noi-alerts_mapping.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/data/trainingdata/event/$appgroupid/$appid/$version/mapping.json
oc cp ./tools/5_training/1_events/trainingdata/event-noi-alerts_mapping.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/train/ingest_configs/event/$appgroupid-$appid-ingest_conf.json

# Logs
oc cp ./tools/5_training/2_logs/trainingdata/raw/log-sockshop.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/data/trainingdata/log/$appgroupid/$appid/$version/
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

# Sockshop
export appgroupid=k8muiz8w
export appid=emjei3wm
export version=1

# Incident
cd /home/zeno/incident/
cp /home/zeno/train/deploy_model.pyc /home/zeno/train/deploy_model.py
bash index_incidents.sh s3://similar-incident-service/test-incidents_sockshop.json $appgroupid $appid

# Event
cd /home/zeno/train/
python3 train_pipeline.pyc -p "event" -g "$appgroupid" -a "$appid" -v "$version"

# Logs
cd /home/zeno/train/
python3 train_pipeline.pyc -p "log" -g "$appgroupid" -a "$appid" -v "$version"

```





# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
## Data Check
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------


Check Number of log lines per container

cat ./tools/5_training/2_logs/trainingdata/raw/log-sockshop.json|jq '.["kubernetes.container_name"]' | sort | uniq -c

Delete istio-proxy entries

grep -v 'kubernetes.container_name":"details' ./tools/5_training/2_logs/trainingdata/raw/log-bookinfo.json > final.json





aws s3 ls s3://event-group --recursive
aws s3 ls s3://event-grouping-service --recursive
aws s3 ls s3://event-ingest --recursive
aws s3 ls s3://log-anomaly --recursive
aws s3 ls s3://log-ingest/$appgroupid/$appid --recursive
aws s3 ls s3://log-model --recursive
aws s3 ls s3://similar-incident-service --recursive
aws s3 ls s3://
aws s3 ls s3://


# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
## Get Data from Humio
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------

"kubernetes.namespace_name" = bookinfo | @rawstring != /error/i
| "kubernetes.container_name" != "istio-proxy"


Log format from Humio --> Export (ndjson)

Check Number of log lines per container

cat ./tools/5_training/2_logs/trainingdata/raw/log-bookinfo.json|jq '.["kubernetes.container_name"]' | sort | uniq -c

Delete istio-proxy entries

grep -v 'kubernetes.container_name":"details' ./tools/5_training/2_logs/trainingdata/raw/log-bookinfo.json > final.json






## Redeploy the model (check in flink)

```bash
cd /home/zeno/train/
python3 deploy_model.pyc -p "log" -g "$appgroupid" -a "$appid" -v "$version"
```

