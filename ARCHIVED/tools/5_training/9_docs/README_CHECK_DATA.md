# ----------------------------------------------------------------------------------------------------------------------------------------------------------
## Data Check
# ----------------------------------------------------------------------------------------------------------------------------------------------------------



## Check Number of log lines per container

```bash
cat ./tools/5_training/2_logs/trainingdata/raw/log-bookinfo.json|jq '.["kubernetes.container_name"]' | sort | uniq -c
```

## Delete istio-proxy entries

```bash
grep -v 'kubernetes.container_name":"details' ./tools/5_training/2_logs/trainingdata/raw/log-bookinfo.json > final.json
```

