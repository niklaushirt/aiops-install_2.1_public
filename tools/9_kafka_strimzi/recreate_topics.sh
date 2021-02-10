check_create_kafka_topic () {
        topic_name=$1

        sleep 10s

        topics=$(oc get kafkatopics | awk '{print $1;}')

        if [[ "$topics" != *"$topic_name"* ]]; then
                echo "WARNING: '$topic_name' kafka topic doesn't exist ... creating it ..."

                sed "s/TOPIC-NAME/$topic_name/g" topic.yaml > $topic_name.yaml
                oc create -f $topic_name.yaml
        else
                echo "INFO: '$topic_name' kafka topic exists ... patching it ..."
                oc patch kafkatopic "$topic_name" --patch '{"spec":{"config":{"retention.ms":1800000,"segment.bytes":1073741824}}}' --type=merge
        fi
}


delete_kafka_topic () {
        topic_name=$1
        echo "II. DELETING KAFKA TOPIC $topic_name"

       
                echo "Deleting Kafka Topic: $topic_name"
                oc delete kafkatopic $topic_name
   
        echo ""
}



create_kafka_topics () {


        echo "V. CREATING KAFKA TOPICS"
        #delete_kafka_topic "normalized-alerts-zinwtouu-56swtm9t"
        delete_kafka_topic "derived-stories"
        #delete_kafka_topic "windowed-logs-zinwtouu-56swtm9t"

        echo "V. CREATING KAFKA TOPICS"
        #check_create_kafka_topic "normalized-alerts-zinwtouu-56swtm9t"
        check_create_kafka_topic "derived-stories"
        #check_create_kafka_topic "windowed-logs-zinwtouu-56swtm9t"
        

        echo ""
}


create_kafka_topics