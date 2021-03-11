#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ADAPT VALUES
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



# Name of the Application (bookinfo, sockshop, kubetoy)
export application_name=kubetoy
export appgroupid=p8agtlvy
export appid=wvaw2akr
export version=1




#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# DO NOT EDIT BELOW
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------










































echo "   __________  __ ___       _____    ________            "
echo "  / ____/ __ \/ // / |     / /   |  /  _/ __ \____  _____"
echo " / /   / /_/ / // /| | /| / / /| |  / // / / / __ \/ ___/"
echo "/ /___/ ____/__  __/ |/ |/ / ___ |_/ // /_/ / /_/ (__  ) "
echo "\____/_/      /_/  |__/|__/_/  |_/___/\____/ .___/____/  "
echo "                                          /_/            "
echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo ""
echo " 🚀  AI OPS Training"
echo ""
echo "***************************************************************************************************************************************************"
echo "  "
echo "   🔎  Training for Application $application_name "
echo "         Application Group  : $appgroupid"
echo "         Application        : $appid"
echo "         Version            : $version"
echo "  "
echo "***************************************************************************************************************************************************"


  read -p "Does this sound right? [y,N] " DO_COMM
  if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
      echo "✅ Ok, continuing..."
  else
    echo "❌ Aborted"
    exit 1
  fi

oc project zen

executeInTrainingPod(){
  title=$1
  command=$2
  echo "🛰️   $title:     $command"
  oc exec -it $TRAINING_POD -- $command
}


printForTrainingPod(){
  command=$1
  echo "$command"
}


export TRAINING_POD=$(oc get po |grep model-train-console|awk '{print$1}')
export SIMILAR_INCIDENTS=similar-incident-service
export EVENT_INGEST=event-ingest
export LOG_INGEST=log-ingest


echo "Training pod is $TRAINING_POD"
echo "  "
echo "  "
echo "  "
echo "  "
echo "***************************************************************************************************************************************************"
echo " 🚀  Create Directories in Training Pod"
echo "***************************************************************************************************************************************************"
executeInTrainingPod "Create Events Directory" "mkdir -p /home/zeno/data/trainingdata/event/$appgroupid/$appid/$version/raw"
executeInTrainingPod "Create Incident Directory" "mkdir -p /home/zeno/data/trainingdata/incident/"




echo "  "
echo "  "
echo "  "
echo "  "
echo "***************************************************************************************************************************************************"
echo " 🚀  Upload Data to Training Pod"
echo "***************************************************************************************************************************************************"

# Incident
echo "📥 Copy Incident Data to Learner Pod"
oc cp ./tools/5_training/3_incidents/trainingdata/test-incidents_$application_name.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/data/trainingdata/incident/test-incidents_$application_name.json


# Event
echo "📥 Copy Event Data to Learner Pod"
echo " ↳--> Copy Event Raw Data"
oc cp ./tools/5_training/1_events/trainingdata/raw/alerts-noi-$application_name.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/data/trainingdata/event/$appgroupid/$appid/$version/raw/noi-alerts.json
echo " ↳--> Copy Event Mapping"
oc cp ./tools/5_training/1_events/trainingdata/event-noi-alerts_mapping.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/data/trainingdata/event/$appgroupid/$appid/$version/mapping.json
echo " ↳--> Copy Event Mapping Global"
oc cp ./tools/5_training/1_events/trainingdata/event-noi-alerts_mapping.json $(oc get po |grep model-train-console|awk '{print $1}'):/home/zeno/train/ingest_configs/event/$appgroupid-$appid-ingest_conf.json






echo "  "
echo "  "
echo "  "
echo "  "
echo "***************************************************************************************************************************************************"
echo " 🚀  Execute the following lines in the Training Pod (Copy/Paste)"
echo "***************************************************************************************************************************************************"

echo "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
echo "  "
echo "  "



echo "#----------------------------------------------------------------------------------------------------------------------------------------"
echo "# Create S3 Buckets"
echo "#----------------------------------------------------------------------------------------------------------------------------------------"
# Create S3 Buckets
printForTrainingPod "aws s3 mb s3://$SIMILAR_INCIDENTS"
printForTrainingPod "aws s3 mb s3://$EVENT_INGEST"


echo "  "
echo "  "
echo "#----------------------------------------------------------------------------------------------------------------------------------------"
echo "# Remove existing training data from S3 Buckets"
echo "#----------------------------------------------------------------------------------------------------------------------------------------"
# Remove existing training data from S3 Buckets
printForTrainingPod "aws s3 rm s3://$SIMILAR_INCIDENTS/test-incidents_$application_name.json"
printForTrainingPod "aws s3 rm s3://$EVENT_INGEST/$appgroupid/$appid/$version/ --recursive"


echo "  "
echo "  "
echo "#----------------------------------------------------------------------------------------------------------------------------------------"
echo "# Sync training data to S3 Buckets"
echo "#----------------------------------------------------------------------------------------------------------------------------------------"
# Sync training data to S3 Buckets
printForTrainingPod "aws s3 sync /home/zeno/data/trainingdata/incident/ s3://$SIMILAR_INCIDENTS/"
printForTrainingPod "aws s3 sync /home/zeno/data/trainingdata/event/ s3://$EVENT_INGEST/"



echo "  "
echo "  "
echo "#----------------------------------------------------------------------------------------------------------------------------------------"
echo "# Train Incident"
echo "#----------------------------------------------------------------------------------------------------------------------------------------"
# Train Incident
printForTrainingPod "cd /home/zeno/incident/"
printForTrainingPod "cp /home/zeno/train/deploy_model.pyc /home/zeno/train/deploy_model.py"
printForTrainingPod "bash index_incidents.sh s3://similar-incident-service/test-incidents_$application_name.json $appgroupid $appid"
printForTrainingPod "rm /home/zeno/train/deploy_model.py"


echo "  "
echo "  "
echo "#----------------------------------------------------------------------------------------------------------------------------------------"
echo "# Train Event"
echo "#----------------------------------------------------------------------------------------------------------------------------------------"
# Train Event
printForTrainingPod "cd /home/zeno/train/"
printForTrainingPod "python3 train_pipeline.pyc -p "event" -g "$appgroupid" -a "$appid" -v "$version""



echo "  "
echo "  "
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"

echo "  "
echo "  "
echo "  "
echo "  "
echo "***************************************************************************************************************************************************"
echo ""
echo " 🚀  Now entering Learner Pod"
echo ""
echo "***************************************************************************************************************************************************"


oc project zen
oc exec -it $(oc get po |grep model-train-console|awk '{print$1}') bash



echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo ""
echo " ✅  AI OPS Training.... DONE...."
echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"