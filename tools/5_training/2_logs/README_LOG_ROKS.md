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
# Bookinfo
export appgroupid=a7fnt4s6
export appid=q22ruydf
export version=1

mkdir -p /home/zeno/data/trainingdata/log/$appgroupid/$appid/$version/


# Sockshop
export appgroupid=a7fnt4s6
export appid=kpwliwck
export version=1

mkdir -p /home/zeno/data/trainingdata/log/$appgroupid/$appid/$version/
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

oc cp ./tools/5_training/2_logs/trainingdata/raw/log-bookinfo.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/data/trainingdata/log/$appgroupid/$appid/$version/
oc cp ./tools/5_training/2_logs/trainingdata/logs-humio-mapping.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/train/ingest_configs/log/$appgroupid-$appid-ingest_conf.json

# Sockshop
export appgroupid=a7fnt4s6
export appid=kpwliwck
export version=1

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
aws s3 mb s3://$LOG_INGEST
```

### Copy Training Data into MinIO (in training console)

```bash
aws s3 sync /home/zeno/data/trainingdata/log/ s3://$LOG_INGEST/
aws s3 ls s3://$LOG_INGEST/ --recursive
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
python3 train_pipeline.pyc -p "log" -g "$appgroupid" -a "$appid" -v "$version"


# Sockshop
export appgroupid=a7fnt4s6
export appid=kpwliwck
export version=1


cd /home/zeno/train/
python3 train_pipeline.pyc -p "log" -g "$appgroupid" -a "$appid" -v "$version"

```











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

