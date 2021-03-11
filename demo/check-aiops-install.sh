source ./01_config.sh

clear
get_sed

banner
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo " 🚀 AI OPS - Check System"
echo "***************************************************************************************************************************************************"


echo "--------------------------------------------------------------------------------------------"
echo "✅ Check ASM Connection (you should see no errors)"
echo "--------------------------------------------------------------------------------------------"

oc exec $(oc get pod -n zen |grep topology | awk '{print $1}') -n zen -- curl -X GET -k "https://localhost:8443/ready?send_additional_info=true" -H "accept: application/json" 

echo ""
echo ""
echo "--------------------------------------------------------------------------------------------"
echo "✅ Check Topology Pods (must all be Running 1/1 or Completed)"
echo "--------------------------------------------------------------------------------------------"

kubectl get -n noi pods | grep topology-


echo ""
echo ""
echo "--------------------------------------------------------------------------------------------"
echo "✅ Check Gateway Pods (must all be Running 1/1 or Completed)"
echo "--------------------------------------------------------------------------------------------"

kubectl get -n noi pods | grep nikh-




echo ""
echo ""
echo "--------------------------------------------------------------------------------------------"
echo "✅ Check Bookinfo Demo (must be Running 2/2)"
echo "--------------------------------------------------------------------------------------------"

kubectl get -n bookinfo pods | grep ratings

echo ""
echo ""
echo "--------------------------------------------------------------------------------------------"
echo "✅ Check Sockshop Demo (must be Running 1/1)"
echo "--------------------------------------------------------------------------------------------"

kubectl get -n sockinfo pods -l name=catalogue | grep catalogue


echo ""
echo ""
echo "--------------------------------------------------------------------------------------------"
echo "✅ Check Slack Integration (must see Kafkajs: Consumer has joined the group - after a lot of errors)"
echo "--------------------------------------------------------------------------------------------"

oc logs  $(oc get pod |grep chatops-slack-integrator | awk '{print $1}') | tail


echo ""
echo ""
echo "--------------------------------------------------------------------------------------------"
echo "✅ Check Stories and App States empty (must be empty)"
echo "--------------------------------------------------------------------------------------------"

oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k https://localhost:8443/v2/stories" 



oc exec -it $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k https://localhost:8443/v2/application_groups/3mavyiwf/app_states" 


