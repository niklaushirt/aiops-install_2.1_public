# RESET MODELS

```bash
oc project zen
oc exec -it $(oc get po |grep model-train-console|awk '{print$1}') bash
```

```bash
export application_name=bookinfo
export appgroupid=zjecaqq2
export appid=nir5ix68
export version=1





aws s3 sync s3://event-group/ /home/zeno/results/event-group

aws s3 sync s3://event-grouping-service/ /home/zeno/results/event-grouping-service

aws s3 sync s3://event-ingest /home/zeno/results/event-ingest

aws s3 sync s3://log-ingest /home/zeno/results/log-ingest



aws s3 sync s3://log-anomaly /home/zeno/results/log-anomaly
aws s3 sync s3://log-model /home/zeno/results/log-model

```


