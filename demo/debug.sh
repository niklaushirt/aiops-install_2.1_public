
source ./99_config-global.sh

#!/bin/bash
menu_option_one () {
  echo "KAfka Topics"
  oc get kafkatopic -n zen

}

menu_option_two() {
  echo "Monitor Derived Stories"
  mv ca.crt ca.crt.old
  oc extract secret/strimzi-cluster-cluster-ca-cert -n zen --keys=ca.crt

  export sasl_password=$(oc get secret token -n zen --template={{.data.password}} | base64 --decode)
  export BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -n zen -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443
  
  echo "	Press Enter to start, press CTRL-C to stop "
  read

  kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -o -10 -C -t derived-stories 

}

menu_option_three() {
  echo "Monitor Specific Topic"
  mv ca.crt ca.crt.old
  oc extract secret/strimzi-cluster-cluster-ca-cert -n zen --keys=ca.crt
  oc get kafkatopic -n zen | awk '{print $1}'

  export sasl_password=$(oc get secret token -n zen --template={{.data.password}} | base64 --decode)
  export BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -n zen -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443
  
  read -p "Copy Paste Topic from above: " MY_TOPIC

  kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -o -10 -C -t $MY_TOPIC
}
menu_option_four() {
  echo "Not implemented"
}
menu_option_five() {
  echo "Not implemented"
}
menu_option_six() {
  echo "Not implemented"
}


menu_option_77() {
  echo "${explosion} ${exclamation} ${explosion}  Restart Flink Jobs ${explosion} ${exclamation} ${explosion} "
  read -p "Are you really, really, REALLY sure you want to Restart Flink Jobs? [y,N] " DO_COMM
  if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
      oc exec $(oc get pod -n zen |grep controller | awk '{print $1}') -n zen -- /usr/bin/curl -k -X PUT https://localhost:9443/v2/connections/application_groups/1rsoloaz/applications/xeii8qo2/refresh?datasource_type=logs
      oc exec $(oc get pod -n zen |grep controller | awk '{print $1}') -n zen -- /usr/bin/curl -k -X PUT https://localhost:9443/v2/connections/application_groups/1rsoloaz/applications/xeii8qo2/refresh?datasource_type=alerts
  else
    echo "${RED}Aborted${NC}"
  fi
}


menu_option_88() {
  echo "${explosion} ${exclamation} ${explosion}  Reset Slack Integration ${explosion} ${exclamation} ${explosion} "
  read -p "Are you really, really, REALLY sure you want to reset the Slack integration? [y,N] " DO_COMM
  if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
    oc delete kafkatopic -n zen connections
    oc apply -n zen -f ./demo/RESET/connections_topic.yaml
  else
    echo "${RED}Aborted${NC}"
  fi
}


menu_option_99() {
  echo "${explosion} ${exclamation} ${explosion}  Cleaning up data from AI Manager and Event Manager ${explosion} ${exclamation} ${explosion} "
  read -p "Are you really, really, REALLY sure you want to reset the demo? [y,N] " DO_COMM
  if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
    ./demo/RESET/reset-demo.sh
  else
    echo "${RED}Aborted${NC}"
  fi
}



press_enter() {
  echo ""
  echo "	Press Enter to continue "
  read
  clear
}

incorrect_selection() {
  echo "Incorrect selection! Try again."
}

get_sed(){
  # fix sed issue on mac
  OS=$(uname -s | tr '[:upper:]' '[:lower:]')
  SED="sed"
  if [ "${OS}" == "darwin" ]; then
      SED="gsed"
      if [ ! -x "$(command -v ${SED})"  ]; then
      __output "This script requires $SED, but it was not found.  Perform \"brew install gnu-sed\" and try again."
      exit
      fi
  fi
}



clear
get_sed


echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo ""
echo " ${rocket} AI OPS DEBUG${NC}"
echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"

CLUSTER_ROUTE=$(kubectl get routes console -n openshift-console | tail -n 1 2>&1 ) 
CLUSTER_FQDN=$( echo $CLUSTER_ROUTE | awk '{print $2}')
export OCP_CONSOLE_PREFIX=console-openshift-console
export CLUSTER_NAME=$(echo $CLUSTER_FQDN | ${SED} "s/$OCP_CONSOLE_PREFIX.//")
echo "  ${telescope}  Cluster URL: $CLUSTER_NAME"

echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "  "
echo "  "


until [ "$selection" = "0" ]; do
  
  echo ""
  
  echo "  ${magnifying} Observe Kafka Topics "
  echo "    	1  - Get Kafka Topics"
  echo "    	2  - Monitor Derived Stories"
  echo "    	3  - Monitor Specific Topic"
  echo "      "
  echo "" 
  echo ""
  echo "    	0  -  Exit"
  echo ""
  echo ""
  echo ""
  echo "  ${explosion} Danger Zone "
  echo "      77  -  Restart Flink Jobs"
  echo "      88  -  Reset Slack Integration"
  echo "      99  -  Reset the demo environment (DANGER ZONE - approx 5 mins)"
  echo "" 
  echo ""
  echo "  Enter selection: "
  read selection
  echo ""
  case $selection in
    1 ) clear ; menu_option_one ; press_enter ;;
    2 ) clear ; menu_option_two ; press_enter ;;
    3 ) clear ; menu_option_three ; press_enter ;;
    4 ) clear ; menu_option_four ; press_enter ;;
    5 ) clear ; menu_option_five ; press_enter ;;
    6 ) clear ; menu_option_six ; press_enter ;;
    77 ) clear ; menu_option_77 ; press_enter ;;
    88 ) clear ; menu_option_88 ; press_enter ;;
    99 ) clear ; menu_option_99 ; press_enter ;;
    0 ) clear ; exit ;;
    * ) clear ; incorrect_selection ; press_enter ;;
  esac
done










export beer='\xF0\x9f\x8d\xba'
export delivery='\xF0\x9F\x9A\x9A'
export beers='\xF0\x9F\x8D\xBB'
export eyes='\xF0\x9F\x91\x80'
export cloud='\xE2\x98\x81'
export crossbones='\xE2\x98\xA0'
export litter='\xF0\x9F\x9A\xAE'
export fail='\xE2\x9B\x94'
export harpoons='\xE2\x87\x8C'
export tools='\xE2\x9A\x92'
export present='\xF0\x9F\x8E\x81'

export telescope='\xF0\x9F\x94\xAD'
export globe='\xF0\x9F\x8C\x90'
export clock='\xF0\x9F\x95\x93'
export wrench='\xF0\x9F\x94\xA7'
export key='\xF0\x9F\x94\x90'
export magnifying='\xF0\x9F\x94\x8D'
export package='\xF0\x9F\x93\xA6'
export memo='\xF0\x9F\x93\x9D'
export explosion='\xF0\x9F\x92\xA5'
export rocket='\xF0\x9F\x9A\x80'
export cross='\xE2\x9D\x8C'
export healthy='\xE2\x9C\x85'
export whitequestion='\xE2\x9D\x93'
export hand='\xE2\x9C\x8B'
export exclamation='\xE2\x9D\x97'