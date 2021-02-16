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





















































source ./demo/01_config.sh

#!/bin/bash
menu_option_one () {
  echo "Kafka Topics"
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


menu_option_11 () {
  echo "Create Sockshop Topology"
  read -p "Are you really, really, REALLY sure you want to install custom Sockshop Topology? [y,N] " DO_COMM
  if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
      ./demo/sockshop/create-topology.sh
  else
    echo "${RED}Aborted${NC}"
  fi
}

menu_option_12 () {
  echo "Create Bookinfo Topology"
  read -p "Are you really, really, REALLY sure you want to install custom Bookinfo Topology? [y,N] " DO_COMM
  if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
      ./demo/bookinfo/create-topology.sh
  else
    echo "${RED}Aborted${NC}"
  fi

}

menu_option_13 () {
  echo "Create Kubetoy Topology"
  read -p "Are you really, really, REALLY sure you want to install custom Kubetoy Topology? [y,N] " DO_COMM
  if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
      ./demo/kubetoy/create-topology.sh
  else
    echo "${RED}Aborted${NC}"
  fi

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



clear
get_sed


echo "${CYAN}***************************************************************************************************************************************************"
echo "${CYAN}***************************************************************************************************************************************************"
echo "${CYAN}***************************************************************************************************************************************************"
echo "${CYAN}***************************************************************************************************************************************************"
echo "${CYAN}"
echo "${CYAN} ${rocket} AI OPS DEBUG${NC}"
echo "${CYAN}"
echo "${CYAN}***************************************************************************************************************************************************"
echo "${CYAN}***************************************************************************************************************************************************"
echo "${CYAN}***************************************************************************************************************************************************${NC}"

echo "${NC}  Initializing......"

echo "  Checking K8s connection......"
checkK8sConnection

echo "${CYAN}***************************************************************************************************************************************************"
echo "${CYAN}***************************************************************************************************************************************************${NC}"
echo "  "
echo "  "


until [ "$selection" = "0" ]; do
  
  echo ""
  
  echo "  ${magnifying} ${GREEN}Observe Kafka Topics${NC} "
  echo "    	1  - Get Kafka Topics"
  echo "    	2  - Monitor Derived Stories"
  echo "    	3  - Monitor Specific Topic"
  echo "      "
  echo "" 
  echo "  ${rocket} ${RED}Create Topologies${NC} "
  echo "      11  -  Create Sockshop Topology"
  echo "      12  -  Create Bookinfo Topology"
  echo "      13  -  Create Kubetoy Topology"
  echo "" 
  echo "" 
  echo "    	0  -  Exit"
  echo ""
  echo ""
  echo ""
  echo "  ${explosion} ${RED}Danger Zone${NC} "
  echo "      77  -  Restart Flink Jobs"
  echo "      88  -  Reset Slack Integration"
  echo "      99  -  ${RED}Reset the demo environment (DANGER ZONE - approx 5 mins)${NC}"
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
    11 ) clear ; menu_option_11 ; press_enter ;;
    12 ) clear ; menu_option_12 ; press_enter ;;
    13 ) clear ; menu_option_13 ; press_enter ;;
    77 ) clear ; menu_option_77 ; press_enter ;;
    88 ) clear ; menu_option_88 ; press_enter ;;
    99 ) clear ; menu_option_99 ; press_enter ;;
    0 ) clear ; exit ;;
    * ) clear ; incorrect_selection ; press_enter ;;
  esac
done







