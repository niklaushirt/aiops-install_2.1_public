helm install secure-gateway se \                                        ✘   master ● ?
  --namespace zen \
  --set humio-fluentbit.token=$INGEST_TOKEN \
  --values ./tools/4_integrations/humio/humio-agent.yaml