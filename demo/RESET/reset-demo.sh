source ./demo/01_config.sh



# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# Reset Demo - Clean Up
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------

echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Scale up Bookinfo"
echo "--------------------------------------------------------------------------------------------------------------------------------"

oc scale --replicas=1  deployment ratings-v1 -n bookinfo


echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Scale up Sockshop"
echo "--------------------------------------------------------------------------------------------------------------------------------"

oc scale --replicas=1  deployment catalogue -n sock-shop


echo ""
echo ""
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Save existing kafka topics"
echo "--------------------------------------------------------------------------------------------------------------------------------"

kubectl get kafkatopic -n zen| awk '{print $1}' > all_topics_$(date +%s).yaml



echo ""
echo ""
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Delete kafka topics"
echo "--------------------------------------------------------------------------------------------------------------------------------"

kubectl get kafkatopic -n zen| grep window | awk '{print $1}' | xargs kubectl delete kafkatopic -n zen
kubectl get kafkatopic -n zen| grep normalized | awk '{print $1}'| xargs kubectl delete kafkatopic -n zen
kubectl get kafkatopic -n zen| grep derived | awk '{print $1}'| xargs kubectl delete kafkatopic -n zen

echo ""
echo ""
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Restart Pods"
echo "--------------------------------------------------------------------------------------------------------------------------------"

kubectl delete pod $(kubectl get pods | grep anomaly | awk '{print $1;}') --force --grace-period 0
kubectl delete pod $(kubectl get pods | grep event | awk '{print $1;}') --force --grace-period 0

echo ""
echo ""
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Recreate Topics"
echo "--------------------------------------------------------------------------------------------------------------------------------"

kubectl apply -n zen -f ./demo/RESET/create-topics.yaml

export appid=$appid1
createTopics
export appid=$appid2
createTopics
export appid=$appid3
createTopics


echo ""
echo ""
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Kafka topics"
echo "--------------------------------------------------------------------------------------------------------------------------------"

kubectl get kafkatopic -n zen



echo ""
echo ""
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Clear Stories DB"
echo "--------------------------------------------------------------------------------------------------------------------------------"

echo "1/8"
kubectl exec -it $(kubectl get pods | grep persistence | awk '{print $1;}') -- curl -k -X DELETE https://localhost:8443/v2/similar_incident_lists
echo ""
echo "2/8"
kubectl exec -it $(kubectl get pods | grep persistence | awk '{print $1;}') -- curl -k -X DELETE https://localhost:8443/v2/alertgroups
echo ""
echo "3/8"
kubectl exec -it $(kubectl get pods | grep persistence | awk '{print $1;}') -- curl -k -X DELETE https://localhost:8443/v2/app_states
echo ""
echo "4/8"
kubectl exec -it $(kubectl get pods | grep persistence | awk '{print $1;}') -- curl -k -X DELETE https://localhost:8443/v2/stories
echo ""
echo "5/8"
kubectl exec -it $(kubectl get pods | grep persistence | awk '{print $1;}') -- curl -k https://localhost:8443/v2/similar_incident_lists
echo ""
echo "6/8"
kubectl exec -it $(kubectl get pods | grep persistence | awk '{print $1;}') -- curl -k https://localhost:8443/v2/alertgroups
echo ""
echo "7/8"
kubectl exec -it $(kubectl get pods | grep persistence | awk '{print $1;}') -- curl -k https://localhost:8443/v2/application_groups/{application-group-id}/app_states
echo ""
echo "8/8"
kubectl exec -it $(kubectl get pods | grep persistence | awk '{print $1;}') -- curl -k https://localhost:8443/v2/stories
echo ""
echo "Done"

echo ""
echo ""
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Refresh the Flink Jobs"
echo "--------------------------------------------------------------------------------------------------------------------------------"


# Bookinfo
echo "1/6"
kubectl exec -it $(kubectl get pods | grep aio-controller | awk '{print $1;}') -- curl -k -X PUT https://localhost:9443/v2/connections/application_groups/$appgroupid/applications/$appid1/refresh?datasource_type=logs
echo ""
echo "2/6"
kubectl exec -it $(kubectl get pods | grep aio-controller | awk '{print $1;}') -- curl -k -X PUT https://localhost:9443/v2/connections/application_groups/$appgroupid/applications/$appid1/refresh?datasource_type=alerts

# Kubetoy
echo ""
echo "3/6"
kubectl exec -it $(kubectl get pods | grep aio-controller | awk '{print $1;}') -- curl -k -X PUT https://localhost:9443/v2/connections/application_groups/$appgroupid/applications/$appid2/refresh?datasource_type=logs
echo ""
echo "4/6"
kubectl exec -it $(kubectl get pods | grep aio-controller | awk '{print $1;}') -- curl -k -X PUT https://localhost:9443/v2/connections/application_groups/$appgroupid/applications/$appid2/refresh?datasource_type=alerts

# Sockshop
echo ""
echo "5/6"
kubectl exec -it $(kubectl get pods | grep aio-controller | awk '{print $1;}') -- curl -k -X PUT https://localhost:9443/v2/connections/application_groups/$appgroupid/applications/$appid3/refresh?datasource_type=logs
echo ""
echo "6/6"
kubectl exec -it $(kubectl get pods | grep aio-controller | awk '{print $1;}') -- curl -k -X PUT https://localhost:9443/v2/connections/application_groups/$appgroupid/applications/$appid3/refresh?datasource_type=alerts
echo ""
echo "Done"

echo ""
echo ""
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Restart Pods"
echo "--------------------------------------------------------------------------------------------------------------------------------"

kubectl delete pod $(kubectl get pods | grep anomaly | awk '{print $1;}') --force --grace-period 0
kubectl delete pod $(kubectl get pods | grep event | awk '{print $1;}') --force --grace-period 0

SUCCESFUL_RESTART=$(kubectl get pods | grep anomaly | grep 0/1 || true)

while  ([[ $SUCCESFUL_RESTART =~ "0" ]] ); do 
    SUCCESFUL_RESTART=$(kubectl get pods | grep anomaly | grep 0/1 || true)
    echo "wait for Anomaly Pod" 
    sleep 10
done


SUCCESFUL_RESTART=$(kubectl get pods | grep event | grep 0/1 || true)

while  ([[ $SUCCESFUL_RESTART =~ "0" ]] ); do 
    SUCCESFUL_RESTART=$(kubectl get pods | grep event | grep 0/1 || true)
    echo "wait for Anomaly Pod" 
    sleep 10
done


echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "  DONE... You're good to go...."
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------------------------------------------"

