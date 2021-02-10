
source ./99_config-global.sh

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
echo " ${rocket} AI OPS Demo${NC}"
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
  
  echo "  ${fail} Create Service Failures "
  echo "    	1  - [BookInfo] Create failure in BookInfo App (stop Ratings service)"
  echo "    	2  - [Sockshop] Create failure in SockShop App (stop Catalogue service)   "
  echo "    	3  - [Kubetoy] Create repeated Liveness Probe error in Kubetoy App"
  echo "      "
  echo ""
  echo "  ${healthy} Mitigate Service Failures "
  echo "    	5  - [BookInfo] Mitigate failure in BookInfo App (start Ratings service)"
  echo "    	6  - [Sockshop] Mitigate failure in SockShop App (start Catalogue service)"
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
    7 ) clear ; menu_option_seven ; press_enter ;;
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