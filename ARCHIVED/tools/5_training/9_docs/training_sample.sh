oc project zen                                                                                                                ⚙
oc delete pod -n bookinfo $(oc get po -n bookinfo|grep ratings-v1|awk '{print$1}') --force --grace-period=0

***************************************************************************************************************************************************
 🚀  Execute the following lines in the Training Pod (Copy/Paste)
***************************************************************************************************************************************************
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv


#----------------------------------------------------------------------------------------------------------------------------------------
# Create S3 Buckets
#----------------------------------------------------------------------------------------------------------------------------------------
aws s3 mb s3://similar-incident-service
aws s3 mb s3://event-ingest
aws s3 mb s3://log-ingest


#----------------------------------------------------------------------------------------------------------------------------------------
# Remove existing training data from S3 Buckets
#----------------------------------------------------------------------------------------------------------------------------------------
aws s3 rm s3://similar-incident-service/test-incidents_bookinfo.json
aws s3 rm s3://event-ingest/zjecaqq2/nir5ix68/1/ --recursive
aws s3 rm s3://log-ingest/zjecaqq2/nir5ix68/1/ --recursive


#----------------------------------------------------------------------------------------------------------------------------------------
# Sync training data to S3 Buckets
#----------------------------------------------------------------------------------------------------------------------------------------
aws s3 sync /home/zeno/data/trainingdata/incident/ s3://similar-incident-service/
aws s3 sync /home/zeno/data/trainingdata/event/ s3://event-ingest/
aws s3 sync /home/zeno/data/trainingdata/log/ s3://log-ingest/


#----------------------------------------------------------------------------------------------------------------------------------------
# Train Incident
#----------------------------------------------------------------------------------------------------------------------------------------
cd /home/zeno/incident/
cp /home/zeno/train/deploy_model.pyc /home/zeno/train/deploy_model.py
bash index_incidents.sh s3://similar-incident-service/test-incidents_bookinfo.json zjecaqq2 nir5ix68
rm /home/zeno/train/deploy_model.py


#----------------------------------------------------------------------------------------------------------------------------------------
# Train Event
#----------------------------------------------------------------------------------------------------------------------------------------
cd /home/zeno/train/
python3 train_pipeline.pyc -p event -g zjecaqq2 -a nir5ix68 -v 1


#----------------------------------------------------------------------------------------------------------------------------------------
# Train Logs
#----------------------------------------------------------------------------------------------------------------------------------------
cd /home/zeno/train/
python3 train_pipeline.pyc -p log -g zjecaqq2 -a nir5ix68 -v 1


#----------------------------------------------------------------------------------------------------------------------------------------
# If you get errors (error copying files log-model/training-...)
#----------------------------------------------------------------------------------------------------------------------------------------
python3 deploy_model.pyc -p log -g zjecaqq2 -a nir5ix68 -v 1


^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

python3 train_pipeline.pyc -p "log" -g "zjecaqq2" -a "nir5ix68" -v "1" --retrain '{"start_time":"2021-02-02T00","end_time":"2021-03-02T00"}'

