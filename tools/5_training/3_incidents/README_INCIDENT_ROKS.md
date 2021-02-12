# AIOPS AI Manager - training


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

Create Directory

```bash

mkdir -p /home/zeno/data/trainingdata/incident/

```



# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
## Copy to Container
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------


```bash
oc cp ./tools/5_training/3_incidents/trainingdata/test-incidents_kubetoy.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/data/trainingdata/incident/test-incidents_kubetoy.json
oc cp ./tools/5_training/3_incidents/trainingdata/test-incidents_bookinfo.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/data/trainingdata/incident/test-incidents_bookinfo.json
oc cp ./tools/5_training/3_incidents/trainingdata/test-incidents_sockshop.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/data/trainingdata/incident/test-incidents_sockshop.json

```




# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
## Prepare training data
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------


### Create Bucket (in training console)

```bash
aws s3 mb s3://$SIMILAR_INCIDENTS
```

### Copy Training Data into MinIO (in training console)

```bash
aws s3 sync /home/zeno/data/trainingdata/incident/ s3://$SIMILAR_INCIDENTS/
aws s3 ls s3://$SIMILAR_INCIDENTS/ --recursive
```


# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
## Train the model (in training console)
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------

```bash
cd /home/zeno/incident/
cp /home/zeno/train/deploy_model.pyc /home/zeno/train/deploy_model.py

# Bookinfo
export appgroupid=a7fnt4s6
export appid=q22ruydf
export version=1
bash index_incidents.sh s3://similar-incident-service/test-incidents_bookinfo.json $appgroupid $appid



# Kubetoy
export appgroupid=a7fnt4s6
export appid=p0ew17xn
export version=1
bash index_incidents.sh s3://similar-incident-service/test-incidents_kubetoy.json $appgroupid $appid


# Sockshop
export appgroupid=a7fnt4s6
export appid=kpwliwck
export version=1
bash index_incidents.sh s3://similar-incident-service/test-incidents_sockshop.json $appgroupid $appid

```



