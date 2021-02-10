# AIOPS AI Manager - EVENT MODEL TRAINING ROKS CH


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

Create Directory

```bash
# Bookinfo
export appgroupid=a7fnt4s6
export appid=q22ruydf
export version=1


mkdir -p /home/zeno/data/trainingdata/event/$appgroupid/$appid/$version/raw



# Kubetoy
export appgroupid=a7fnt4s6
export appid=p0ew17xn
export version=1

mkdir -p /home/zeno/data/trainingdata/event/$appgroupid/$appid/$version/raw



# Sockshop
export appgroupid=a7fnt4s6
export appid=81zvikm1
export version=1

mkdir -p /home/zeno/data/trainingdata/event/$appgroupid/$appid/$version/raw
```



# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
## Upload Data to Triaining Console (from Host)
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------


```bash
# Bookinfo
export appgroupid=a7fnt4s6
export appid=q22ruydf
export version=1

oc cp ./tools/5_training/1_events/trainingdata/raw/alerts-noi-bookinfo.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/data/trainingdata/event/$appgroupid/$appid/$version/raw/noi-alerts.json
oc cp ./tools/5_training/1_events/trainingdata/event-noi-alerts_mapping.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/data/trainingdata/event/$appgroupid/$appid/$version/mapping.json
oc cp ./tools/5_training/1_events/trainingdata/event-noi-alerts_mapping.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/train/ingest_configs/event/$appgroupid-$appid-ingest_conf.json

# Kubetoy
export appgroupid=a7fnt4s6
export appid=p0ew17xn
export version=1

oc cp ./tools/5_training/1_events/trainingdata/raw/alerts-noi-kubetoy.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/data/trainingdata/event/$appgroupid/$appid/$version/raw/noi-alerts.json
oc cp ./tools/5_training/1_events/trainingdata/event-noi-alerts_mapping.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/data/trainingdata/event/$appgroupid/$appid/$version/mapping.json
oc cp ./tools/5_training/1_events/trainingdata/event-noi-alerts_mapping.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/train/ingest_configs/event/$appgroupid-$appid-ingest_conf.json


# Sockshop
export appgroupid=a7fnt4s6
export appid=81zvikm1
export version=1

oc cp ./tools/5_training/1_events/trainingdata/raw/alerts-noi-sockshop.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/data/trainingdata/event/$appgroupid/$appid/$version/raw/noi-alerts.json
oc cp ./tools/5_training/1_events/trainingdata/event-noi-alerts_mapping.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/data/trainingdata/event/$appgroupid/$appid/$version/mapping.json
oc cp ./tools/5_training/1_events/trainingdata/event-noi-alerts_mapping.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/train/ingest_configs/event/$appgroupid-$appid-ingest_conf.json
```




# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
## Prepare training data (in the Training Console)
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------


### Create Bucket (in training console)

```bash
aws s3 mb s3://$EVENT_INGEST
```

### Copy Training Data into MinIO (in training console)

```bash
aws s3 sync /home/zeno/data/trainingdata/event/ s3://$EVENT_INGEST/
aws s3 ls s3://$EVENT_INGEST/ --recursive
```


# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
## Train the model  (in the Training Console)
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------

```bash
# Bookinfo
export appgroupid=a7fnt4s6
export appid=q22ruydf
export version=1

cd /home/zeno/train/
python3 train_pipeline.pyc -p "event" -g "$appgroupid" -a "$appid" -v "$version"



# Kubetoy
export appgroupid=a7fnt4s6
export appid=p0ew17xn
export version=1

cd /home/zeno/train/
python3 train_pipeline.pyc -p "event" -g "$appgroupid" -a "$appid" -v "$version"




# Sockshop
export appgroupid=a7fnt4s6
export appid=81zvikm1
export version=1

cd /home/zeno/train/
python3 train_pipeline.pyc -p "event" -g "$appgroupid" -a "$appid" -v "$version"


```


