



source ./demo/01_config.sh
source ./99_config-global.sh

clear

echo "🚀 Create NOI - AI Manager Gateways "
echo ""
echo ""
echo "  Initializing....."
echo ""
echo ""


token=$(oc get secret token -n zen --template={{.data.password}} | base64 --decode)

route=$(oc get routes -n zen strimzi-cluster-kafka-bootstrap -o=jsonpath='{.status.ingress[0].host}{"\n"}')


echo "📥 Creating Gateways for:"
echo "     🔎 Strimzi Route: $route"
echo "     🔎 Kafka Token  : $token"
echo ""
echo ""

if [[ $appid_bookinfo == "not_configured" ]];
then
    echo "❌ Skipping gateway creation for Bookinfo"
    echo ""
    echo ""
else
    ALERTS_NOI_TOPIC="alerts-noi-$appgroupid_bookinfo-$appid_bookinfo"
    cp ./tools/3_integrationgateway/nikh-bookinfo-demo-noi-aimgr-gateway-config-template.yaml /tmp/nikh-bookinfo-demo-noi-aimgr-gateway-config-template.yaml
    ${SED} -i "s/<STRIMZI_URL>/$route/" /tmp/nikh-bookinfo-demo-noi-aimgr-gateway-config-template.yaml
    ${SED} -i "s/<ALERTS_NOI_TOPIC>/$ALERTS_NOI_TOPIC/" /tmp/nikh-bookinfo-demo-noi-aimgr-gateway-config-template.yaml
    ${SED} -i "s/<STRIMZI_PWD>/$token/" /tmp/nikh-bookinfo-demo-noi-aimgr-gateway-config-template.yaml

    kubectl apply -n noi -f /tmp/nikh-bookinfo-demo-noi-aimgr-gateway-config-template.yaml
    kubectl apply -n noi -f ./tools/3_integrationgateway/nikh-bookinfo-demo-noi-aimgr-gateway.yaml

    echo "✅ Gateway created for Bookinfo"
    echo ""
    echo ""
fi 


if [[ $appid_robotshop == "not_configured" ]];
then
    echo "❌ Skipping gateway creation for Robotshop"
    echo ""
    echo ""
else
    ALERTS_NOI_TOPIC="alerts-noi-$appgroupid_robotshop-$appid_robotshop"
    cp ./tools/3_integrationgateway/nikh-robotshop-demo-noi-aimgr-gateway-config-template.yaml /tmp/nikh-robotshop-demo-noi-aimgr-gateway-config-template.yaml
    ${SED} -i "s/<STRIMZI_URL>/$route/" /tmp/nikh-robotshop-demo-noi-aimgr-gateway-config-template.yaml
    ${SED} -i "s/<ALERTS_NOI_TOPIC>/$ALERTS_NOI_TOPIC/" /tmp/nikh-robotshop-demo-noi-aimgr-gateway-config-template.yaml
    ${SED} -i "s/<STRIMZI_PWD>/$token/" /tmp/nikh-robotshop-demo-noi-aimgr-gateway-config-template.yaml

    kubectl apply -n noi -f /tmp/nikh-robotshop-demo-noi-aimgr-gateway-config-template.yaml
    kubectl apply -n noi -f ./tools/3_integrationgateway/nikh-robotshop-demo-noi-aimgr-gateway.yaml

    echo "✅ Gateway created for Robotshop"
    echo ""
    echo ""
fi 


if [[ $appid_kubetoy == "not_configured" ]];
then
    echo "❌ Skipping gateway creation for Kubetoy"
    echo ""
    echo ""
else
    ALERTS_NOI_TOPIC="alerts-noi-$appgroupid_kubetoy-$appid_kubetoy"
    cp ./tools/3_integrationgateway/nikh-kubetoy-demo-noi-aimgr-gateway-config-template.yaml /tmp/nikh-kubetoy-demo-noi-aimgr-gateway-config-template.yaml
    ${SED} -i "s/<STRIMZI_URL>/$route/" /tmp/nikh-kubetoy-demo-noi-aimgr-gateway-config-template.yaml
    ${SED} -i "s/<ALERTS_NOI_TOPIC>/$ALERTS_NOI_TOPIC/" /tmp/nikh-kubetoy-demo-noi-aimgr-gateway-config-template.yaml
    ${SED} -i "s/<STRIMZI_PWD>/$token/" /tmp/nikh-kubetoy-demo-noi-aimgr-gateway-config-template.yaml

    kubectl apply -n noi -f /tmp/nikh-kubetoy-demo-noi-aimgr-gateway-config-template.yaml
    kubectl apply -n noi -f ./tools/3_integrationgateway/nikh-kubetoy-demo-noi-aimgr-gateway.yaml

    echo "✅ Gateway created for Kubetoy"
    echo ""
    echo ""
fi 


echo "✅ Gateways created"
echo " DONE......."
echo ""


exit 1

DEMO_TOKEN=$(oc -n default get secret $(oc get secret -n default |grep -m1 demo-admin-token|awk '{print$1}') -o jsonpath='{.data.token}'|base64 -d)
DEMO_URL=$(oc status|grep -m1 "In project"|awk '{print$6}')
echo  "oc login --token=$DEMO_TOKEN --server=$DEMO_URL"


kubectl patch cm demotoy-configmap-env -n default -p '{"data": {"OCP_URL": "'${DEMO_URL}'"}}' --type=merge
kubectl patch cm demotoy-configmap-env -n default -p '{"data": {"TOKEN": "'${DEMO_TOKEN}'"}}' --type=merge
kubectl patch cm demotoy-configmap-env -n default -p '{"data": {"SEC_TOKEN": "demo"}}' --type=merge


oc delete pod -n default $(oc get po -n default|grep demotoy|awk '{print$1}') --force --grace-period=0 



  kafka_client_jaas='KafkaClient {
     org.apache.kafka.common.security.scram.ScramLoginModule required
     tokenauth="true"
     username="token"
     password="TODO" 
    };'


  kafka_client_jaas='KafkaClient {\n    org.apache.kafka.common.security.scram.ScramLoginModule required\n    tokenauth="true"\n    username="token"\n    password="TODO"};'