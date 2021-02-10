#!/bin/bash
menu_option_one () {
  echo "Create failure in BookInfo App (stop Ratings service)"
  ./demo/bookinfo/create-incident.sh
}

menu_option_two() {
  echo "Create failure in SockShop App (stop Catalogue service)"
  ./demo/sockshop/create-incident.sh
}

menu_option_three() {
  echo "Create repeated Liveness Probe error in Kubetoy App"
  ./demo/kubetoy/create-incident.sh #1>/dev/null 2>&1
}
menu_option_four() {
  echo "Not implemented"
}
menu_option_five() {
  echo "Mitigate failure in BookInfo App (start Ratings service)"
  ./demo/bookinfo/remove-incident.sh

}
menu_option_six() {
  echo "Mitigate failure in SockShop App (start Catalogue service)"
  ./demo/sockshop/remove-incident.sh

}
menu_option_seven() {
  echo "Not implemented"

}
menu_option_eight() {
  echo "Cleaning up data from AI Manager and Event Manager"
  read -p "Are yo sure you want to reset the demo? [y,N]" DO_COMM
  if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
    ./demo/RESET/reset-demo.sh
  else
    echo "${RED}Installation Aborted${NC}"
  fi

  
}



press_enter() {
  echo ""
  echo -n "	Press Enter to continue "
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
echo " AI OPS Demo${NC}"
echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"

CLUSTER_ROUTE=$(kubectl get routes console -n openshift-console | tail -n 1 2>&1 ) 
CLUSTER_FQDN=$( echo $CLUSTER_ROUTE | awk '{print $2}')
export OCP_CONSOLE_PREFIX=console-openshift-console
export CLUSTER_NAME=$(echo $CLUSTER_FQDN | ${SED} "s/$OCP_CONSOLE_PREFIX.//")
echo "Cluster URL: $CLUSTER_NAME"

echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "  "
echo "  "


until [ "$selection" = "0" ]; do
  
  echo ""
  echo "    	1  -  [BookInfo] Create failure in BookInfo App (stop Ratings service)"
  echo "    	2  -  [Sockshop ] Create failure in SockShop App (stop Catalogue service)   "
  echo "    	3  -  [Kubetoy] Create repeated Liveness Probe error in Kubetoy App"
  echo "      "
  echo ""
  echo "    	5  -  [BookInfo] Mitigate failure in BookInfo App (start Ratings service)"
  echo "    	6  -  [Sockshop ] Mitigate failure in SockShop App (start Catalogue service)"
  echo "" 
  echo ""
  echo "        8  -  Reset the demo environment (DANGER ZONE - approx 10 mins)"
  echo "" 
  echo ""
  echo "    	0  -  Exit"
  echo ""
  echo -n "  Enter selection: "
  read selection
  echo ""
  case $selection in
    1 ) clear ; menu_option_one ; press_enter ;;
    2 ) clear ; menu_option_two ; press_enter ;;
    3 ) clear ; menu_option_three ; press_enter ;;
    4 ) clear ; menu_option_four ; press_enter ;;
    5 ) clear ; menu_option_five ; press_enter ;;
    6 ) clear ; menu_option_six ; press_enter ;;
    7 ) clear ; menu_option_seven ; press_enter ;;
    8 ) clear ; menu_option_eight ; press_enter ;;
    0 ) clear ; exit ;;
    * ) clear ; incorrect_selection ; press_enter ;;
  esac
done
