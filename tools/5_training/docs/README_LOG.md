# AIOPS AI Manager - training

# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
## Get Data from Humio
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------

"kubernetes.namespace_name" = bookinfo | @rawstring != /error/i
| "kubernetes.container_name" != "istio-proxy"


Log format from Humio --> Export (ndjson)


# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
## Upload Data
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
export appgroupid=3mavyiwf
export appid=gltjtbrk
export version=1



# Bookinfo
export appgroupid=3mavyiwf
export appid=gj8nhgir
export version=1


# Kubetoy
export appgroupid=3mavyiwf
export appid=sszctxgk
export version=1


mkdir -p /home/zeno/data/trainingdata/log/$appgroupid/$appid/$version/

```


# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
### Copy to Container
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------

```bash


# Sockshop
export appgroupid=3mavyiwf
export appid=gltjtbrk
export version=1


# Kubetoy
export appgroupid=3mavyiwf
export appid=sszctxgk
export version=1


# Bookinfo
export appgroupid=3mavyiwf
export appid=gj8nhgir
export version=1


rm ./tools/5_training/trainingdata/.DS_Store
rm ./tools/5_training/trainingdata/raw/.DS_Store

oc cp ./tools/5_training/trainingdata/raw/log-sockshop.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/data/trainingdata/log/$appgroupid/$appid/$version/

oc cp ./tools/5_training/trainingdata/raw/log-bookinfo.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/data/trainingdata/log/$appgroupid/$appid/$version/
oc cp ./tools/5_training/trainingdata/logs-humio-mapping.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/train/ingest_configs/log/$appgroupid-$appid-ingest_conf.json

```



# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
## Prepare training data (in training console)
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------


### Create Bucket (in training console)

```bash
aws s3 mb s3://$LOG_INGEST
aws s3 ls log-ingest --recursive

```

### Copy Training Data into MinIO (in training console)

```bash
aws s3 sync /home/zeno/data/trainingdata/log/ s3://$LOG_INGEST/
aws s3 ls s3://log-ingest/$appgroupid/$appid/$version/
```



# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
## Train the model (in training console)
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------


```bash
cd /home/zeno/train/
python3 train_pipeline.pyc -p "log" -g "$appgroupid" -a "$appid" -v "$version"
```


# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
## Fetch Training Logs (in training console)
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------

```bash

aws s3 sync s3://event-group/ /home/zeno/results/event-group

aws s3 sync s3://event-grouping-service/ /home/zeno/results/event-grouping-service

aws s3 sync s3://event-ingest /home/zeno/results/event-ingest

aws s3 sync s3://log-anomaly /home/zeno/results/log-anomaly

aws s3 sync s3://log-ingest /home/zeno/results/log-ingest

aws s3 sync s3://log-model /home/zeno/results/log-model

aws s3 sync s3://similar-incident-service /home/zeno/results/similar-incident-service

```

aws s3 ls s3://log-anomaly --recursive

aws s3 ls s3://log-ingest --recursive

aws s3 ls s3://log-model --recursive

aws s3 rm s3://log-anomaly/JOBS/3mavyiwf/gj8nhgir/ --recursive

aws s3 rm s3://log-model/JOBS/3mavyiwf/gj8nhgir/ --recursive




## Redeploy the model (check in flink)

```bash
cd /home/zeno/train/
python3 deploy_model.pyc -p "log" -g "$appgroupid" -a "$appid" -v "$version"
```



aws s3 rm s3://log-ingest/$appgroupid/$appid/$version/ --recursive
