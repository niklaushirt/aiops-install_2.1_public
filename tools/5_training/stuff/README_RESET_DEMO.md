


# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# Delete Data
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------


Remove training data

```bash
rm -r /home/zeno/data/trainingdata/
aws s3 rm s3:// --recursive
```

Remove Models

```bash
aws s3 rm s3://event-ingest --recursive
aws s3 rm s3://log-ingest --recursive


aws s3 rm s3://event-group --recursive
aws s3 rm s3://event-grouping-service --recursive

aws s3 rm s3://log-anomaly --recursive

aws s3 rm s3://log-model --recursive
aws s3 rm s3://similar-incident-service --recursive
```


Remove DLAAS

```bash
dlaas list
dlaas delete --all
```



Remove Indices

```bash
curl -u $ES_USERNAME:$ES_PASSWORD -XGET https://$ES_ENDPOINT/_cat/indices  --insecure | awk '{print $3}'

curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/ xxxxxxx



curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-sszctxgk-pagerduty_mapping_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-gj8nhgir-1-embedding_pca_model
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-gj8nhgir-1-templates
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-gj8nhgir-1-pca_fe
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-gj8nhgir-1-applications
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-gj8nhgir-20210126-logtrain
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-gj8nhgir-1-training_count_vectors
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-gj8nhgir-log_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-sszctxgk-event_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-gj8nhgir-1-pca_model
curl -u $ES_USERNAME:$ES_PASSWORD --insecure -XDELETE https://$ES_ENDPOINT/3mavyiwf-gj8nhgir-1-embedding_pca_fe


```





