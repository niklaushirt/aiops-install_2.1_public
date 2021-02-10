# AIOPS AI Manager - training


# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# Reset Demo - Clean Up
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------

echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Save existing kafka topics"
echo "--------------------------------------------------------------------------------------------------------------------------------"

oc get kafkatopic -n zen| awk '{print $1}' > all_topics.yaml

echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Delete kafka topics"
echo "--------------------------------------------------------------------------------------------------------------------------------"

oc get kafkatopic -n zen| grep window | awk '{print $1}' | xargs oc delete kafkatopic -n zen
oc get kafkatopic -n zen| grep normalized | awk '{print $1}'| xargs oc delete kafkatopic -n zen
oc get kafkatopic -n zen| grep derived | awk '{print $1}'| xargs oc delete kafkatopic -n zen

echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Restart Pods"
echo "--------------------------------------------------------------------------------------------------------------------------------"

oc delete pod $(oc get pods | grep anomaly | awk '{print $1;}') --force --grace-period 0
oc delete pod $(oc get pods | grep event | awk '{print $1;}') --force --grace-period 0

echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Recreate Topics"
echo "--------------------------------------------------------------------------------------------------------------------------------"

kubectl apply -n zen -f ./demo/RESET/create-topics.yaml

echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Clear Stories DB"
echo "--------------------------------------------------------------------------------------------------------------------------------"

oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- curl -k -X DELETE https://localhost:8443/v2/similar_incident_lists
oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- curl -k -X DELETE https://localhost:8443/v2/alertgroups
oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- curl -k -X DELETE https://localhost:8443/v2/app_states
oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- curl -k -X DELETE https://localhost:8443/v2/stories
oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- curl -k https://localhost:8443/v2/similar_incident_lists
oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- curl -k https://localhost:8443/v2/alertgroups
oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- curl -k https://localhost:8443/v2/application_groups/{application-group-id}/app_states
oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- curl -k https://localhost:8443/v2/stories


echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Refresh the Flink Jobs"
echo "--------------------------------------------------------------------------------------------------------------------------------"

oc exec -it $(oc get pods | grep aio-controller | awk '{print $1;}') -- curl -k -X PUT https://localhost:9443/v2/connections/application_groups/3mavyiwf/applications/gltjtbrk/refresh?datasource_type=logs
oc exec -it $(oc get pods | grep aio-controller | awk '{print $1;}') -- curl -k -X PUT https://localhost:9443/v2/connections/application_groups/3mavyiwf/applications/gltjtbrk/refresh?datasource_type=alerts
oc exec -it $(oc get pods | grep aio-controller | awk '{print $1;}') -- curl -k -X PUT https://localhost:9443/v2/connections/application_groups/3mavyiwf/applications/gj8nhgir/refresh?datasource_type=logs
oc exec -it $(oc get pods | grep aio-controller | awk '{print $1;}') -- curl -k -X PUT https://localhost:9443/v2/connections/application_groups/3mavyiwf/applications/gj8nhgir/refresh?datasource_type=alerts
oc exec -it $(oc get pods | grep aio-controller | awk '{print $1;}') -- curl -k -X PUT https://localhost:9443/v2/connections/application_groups/3mavyiwf/applications/sszctxgk/refresh?datasource_type=logs
oc exec -it $(oc get pods | grep aio-controller | awk '{print $1;}') -- curl -k -X PUT https://localhost:9443/v2/connections/application_groups/3mavyiwf/applications/sszctxgk/refresh?datasource_type=alerts

echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Restart Pods"
echo "--------------------------------------------------------------------------------------------------------------------------------"


SUCCESFUL_RESTART=$(oc get pods | grep anomaly | grep 0/1 || true)

while  ([[ $SUCCESFUL_RESTART =~ "0" ]] ); do 
    SUCCESFUL_RESTART=$(oc get pods | grep anomaly | grep 0/1 || true)
    echo "wait for Anomaly Pod" 
    sleep 10
done


SUCCESFUL_RESTART=$(oc get pods | grep event | grep 0/1 || true)

while  ([[ $SUCCESFUL_RESTART =~ "0" ]] ); do 
    SUCCESFUL_RESTART=$(oc get pods | grep event | grep 0/1 || true)
    echo "wait for Anomaly Pod" 
    sleep 10
done


echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "  DONE"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------------------------------------------"

