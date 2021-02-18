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

menu_option_one () {
  echo "Simulate failure in BookInfo App (stop Ratings service)"
  ./demo/bookinfo/simulate-incident.sh
}

menu_option_two() {
  echo "Simulate failure in Kubetoy App (Liveness Probe error )"
  ./demo/kubetoy/simulate-incident.sh
}

menu_option_three() {
  echo "Simulate failure in SockShop App (stop Catalogue Service)"
  echo "	Press Enter to start, press CTRL-C to stop "
  ./demo/sockshop/simulate-incident.sh
}

menu_option_four() {
  echo "Create repeated Liveness Probe error in Kubetoy App"
  ./demo/kubetoy/create-incident.sh #1>/dev/null 2>&1

}

menu_option_five() {
  echo "Create failure in BookInfo App (stop Ratings service)"
  ./demo/bookinfo/create-incident.sh
}

menu_option_six() {
  echo "Create failure in Sockshop App (stop Ratings service)"
  ./demo/sockshop/create-incident.sh
}


menu_option_11() {
  echo "Mitigate failure in BookInfo App (start Ratings service)"
  ./demo/bookinfo/remove-incident.sh
}

menu_option_12() {
  echo "Mitigate failure in Sockshop App (start Ratings service)"
  ./demo/sockshop/remove-incident.sh
}

menu_option_seven() {
  echo "Not implemented"

}


clear
get_sed


echo "${CYAN}***************************************************************************************************************************************************"
echo "${CYAN}***************************************************************************************************************************************************"
echo "${CYAN}***************************************************************************************************************************************************"
echo "${CYAN}***************************************************************************************************************************************************"
echo "${CYAN}"
echo "${CYAN} ${rocket} AI OPS Demo${NC}"
echo "${CYAN}"
echo "${CYAN}***************************************************************************************************************************************************"
echo "${CYAN}***************************************************************************************************************************************************"
echo "${CYAN}***************************************************************************************************************************************************"

echo "${NC}  Initializing......"

echo "  Checking K8s connection......"
checkK8sConnection

echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "  NOI Webhook is $NETCOOL_WEBHOOK"
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"

echo "  "
echo "  "


until [ "$selection" = "0" ]; do
  
  echo ""
  
  echo "  ${beer} ${ORANGE}Simulate Service Failures ${NC}"
  echo "    	1  - ${CYAN}[BookInfo]${NC} ${ORANGE}Simulate failure in BookInfo App (inject failure logs)${NC}"
  echo "    	2  - ${CYAN}[Kubetoy]${NC}  ${ORANGE}Simulate Liveness Probe error in Kubetoy App${NC}"
  echo "    	3  - ${CYAN}[Sockshop]${NC} ${ORANGE}Simulate failure in SockShop App (inject failure logs)${NC}"
  echo "      "
  echo "  ${fail} ${RED}Create Service Failures ${NC}"
  echo "    	4  - ${CYAN}[Kubetoy]${NC}  ${RED}Create repeated Liveness Probe error in Kubetoy App${NC}"
  echo "    	5  - ${CYAN}[BookInfo]${NC} ${RED}Create failure in BookInfo App (stop Ratings service)${NC}"
  echo "    	6  - ${CYAN}[Sockshop]${NC} ${RED}Create failure in SockShop App (stop Catalogue service)${NC}"
  echo "      "
  echo ""
  echo "  ${healthy} ${GREEN}Mitigate Service Failures ${NC}"
  echo "    	11  - ${CYAN}[BookInfo]${NC} ${GREEN}Mitigate failure in BookInfo App (start Ratings service)${NC}"
  echo "    	12  - ${CYAN}[Sockshop]${NC} ${GREEN}Mitigate failure in Sockshop App (start Catalogue service)${NC}"
  echo "" 
  echo ""
  echo "    	0  -  Exit"
  echo ""
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
    0 ) clear ; exit ;;
    * ) clear ; incorrect_selection ; press_enter ;;
  esac
done

