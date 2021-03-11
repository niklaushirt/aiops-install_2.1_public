# AIOPS AI Manager - LOG ANOMALY TRAINING - BOOKINFO

> ## This document is just for illustration. You can use the automated training scripts

----------------------------------------------------------------------------------------------------------------------------------------------------------
## Prepare Datastructure (in the Training Console)
----------------------------------------------------------------------------------------------------------------------------------------------------------

Log in to Training console 

```bash
oc project zen
oc exec -it $(oc get po |grep model-train-console|awk '{print$1}') bash
```

### Create Directory (in training console)

```bash


export appgroupid=a7fnt4s6
export appid=q22ruydf
export version=1

mkdir -p /home/zeno/data/trainingdata/log/$appgroupid/$appid/$version/
mkdir -p /home/zeno/data/trainingdata/event/$appgroupid/$appid/$version/raw
mkdir -p /home/zeno/data/trainingdata/incident/

```


----------------------------------------------------------------------------------------------------------------------------------------------------------
## Upload Data to Training Console (from Host)
----------------------------------------------------------------------------------------------------------------------------------------------------------

```bash

export appgroupid=a7fnt4s6
export appid=q22ruydf
export version=1

# Incident
oc cp ./tools/5_training/3_incidents/trainingdata/test-incidents_bookinfo.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/data/trainingdata/incident/test-incidents_bookinfo.json

# Event
oc cp ./tools/5_training/1_events/trainingdata/raw/alerts-noi-bookinfo.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/data/trainingdata/event/$appgroupid/$appid/$version/raw/noi-alerts.json
oc cp ./tools/5_training/1_events/trainingdata/event-noi-alerts_mapping.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/data/trainingdata/event/$appgroupid/$appid/$version/mapping.json
oc cp ./tools/5_training/1_events/trainingdata/event-noi-alerts_mapping.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/train/ingest_configs/event/$appgroupid-$appid-ingest_conf.json

# Logs
oc cp ./tools/5_training/2_logs/trainingdata/raw/log-bookinfo.json.gz $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/data/trainingdata/log/$appgroupid/$appid/$version/
oc cp ./tools/5_training/2_logs/trainingdata/logs-humio-mapping.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/train/ingest_configs/log/$appgroupid-$appid-ingest_conf.json



```




----------------------------------------------------------------------------------------------------------------------------------------------------------
## Prepare training data (in the Training Console)
----------------------------------------------------------------------------------------------------------------------------------------------------------


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



----------------------------------------------------------------------------------------------------------------------------------------------------------
## Train the model  (in the Training Console)
----------------------------------------------------------------------------------------------------------------------------------------------------------


```bash

export appgroupid=a7fnt4s6
export appid=q22ruydf
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








