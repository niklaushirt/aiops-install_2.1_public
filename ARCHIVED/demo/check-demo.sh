
source ./01_config.sh

clear
get_sed

banner
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo " 🚀 AI OPS Demo - Check Prerequisites"
echo "***************************************************************************************************************************************************"


echo "  Initializing......"

echo "  Checking Config File......"

 if [[ $appgroupid1 =~ "not_configured" ]];
  then
      echo "      ❗ ERROR: Please copy the 01_config.sh file that you have received by mail into this ./demo folder"
      echo "           ❌ Aborting."
      exit 1
  else 
      echo "      ✅ OK"
  fi








echo "  Checking NOI WebHooks......"


  checkConnection=$(curl --insecure -X "POST" "$NETCOOL_WEBHOOK_HUMIO" -H 'Content-Type: application/json; charset=utf-8' -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896') 


 if [[ $checkConnection =~ "Cannot read property" ]];
  then
      echo "      ✅ OK"
  else 
      echo "      ❗ ERROR: Humio is not accessible"
      echo "           ❌ Aborting."
      exit 1
  fi


  checkConnection=$(curl --insecure -X "POST" "$NETCOOL_WEBHOOK_GIT" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896') >/dev/null 2>&1


 if [[ $checkConnection =~ "deduplicationKey" ]];
  then
      echo "      ✅ OK"
  else 
      echo "      ❗ ERROR: Git Webhook is not accessible"
      echo "           ❌ Aborting."
      exit 1
  fi

  checkConnection=$(curl --insecure -X "POST" "$NETCOOL_WEBHOOK_METRICS" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896') >/dev/null 2>&1


 if [[ $checkConnection =~ "deduplicationKey" ]];
  then
      echo "      ✅ OK"
  else 
      echo "      E❗ RROR: MEtrics Webhook is not accessible"
      echo "           ❌ Aborting."
      exit 1
  fi



  checkConnection=$(curl --insecure -X "POST" "$NETCOOL_WEBHOOK_FALCO" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896') >/dev/null 2>&1

 if [[ $checkConnection =~ "deduplicationKey" ]];
  then
      echo "      ✅ OK"
  else 
      echo "      ❗ ERROR: Falco Webhook is not accessible"
      echo "           ❌ Aborting."
      exit 1
  fi





echo ""
echo "  Checking K8s connection......"
checkK8sConnection

echo ""
echo "      ✅   Checking Bookinfo......"
oc scale --replicas=1  deployment ratings-v1 -n bookinfo

echo ""
echo "      ✅   Checking Sockshop......"
oc scale --replicas=1  deployment catalogue -n sockinfo

# echo "  Restarting Bookinfo......"
#oc delete pods -n bookinfo --all



echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo ""
echo " 🆗 DONE - You're good to go!!!!!"
echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
