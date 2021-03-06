#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ADAPT VALUES in ./01_config.sh
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# DO NOT EDIT BELOW
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------































































source ./01_config.sh
clear
get_sed
checkK8sConnection  >/dev/null 2>&1


echo "."
oc scale --replicas=0  deployment ratings-v1 -n bookinfo >/dev/null 2>&1
oc delete pod -n bookinfo $(oc get po -n bookinfo|grep ratings-v1|awk '{print$1}') --force --grace-period=0 >/dev/null 2>&1
echo "."


sleep 30



./bookinfo/simulate-incident_silent.sh


