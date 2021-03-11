
export BEARER_TOKEN=FSEg3MHJWqCG0L4PGzRJ7OJaengj5cuZ7nItJDlVAUwR
export BASE_URL=aiops-a376efc1170b9b8ace6422196c51e491-0000.eu-de.containers.appdomain.cloud

export NOI_URL='https://netcool.demo-noi.aiops-a376efc1170b9b8ace6422196c51e491-0000.eu-de.containers.appdomain.cloud/norml/webhook/humio/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/b772dd26-50e2-4f7e-9190-806aa6205e28/njlLpozGhjWIBobyXogHf5ICFaPgd4K5m_5EcZW5Y4s'


cp ./tools/4_integrations/humio/REST/alertnotifier.json /tmp/alertnotifier.json
gsed -i "s#<NOI_URL>#$NOI_URL#" /tmp/alertnotifier.json

curl -X "POST" "http://humio-humio-logging.$BASE_URL/api/v1/repositories/aiops/alertnotifiers" -H 'Content-Type: application/json' -H 'Authorization: Bearer '$BEARER_TOKEN -d @/tmp/alertnotifier.json




export HUMIO_NOTIFIER_ID=$(curl "http://humio-humio-logging.$BASE_URL/api/v1/repositories/aiops/alertnotifiers" -H 'Content-Type: application/json' -H 'Authorization: Bearer '$BEARER_TOKEN -H 'Cookie: 5aeaa98598eb11937cc50f57efd7ab5b=2f04ddcffebab6cce361fe37ec1edcb6' | grep '"id"'  | awk '{print $1}' | grep '"id"' | cut -d "," -f 2 | cut -d ":" -f 2 | cut -d '"' -f 2)

cp ./tools/4_integrations/humio/REST/alerts_1.json /tmp/alerts_1.json
cp ./tools/4_integrations/humio/REST/alerts_2.json /tmp/alerts_2.json
cp ./tools/4_integrations/humio/REST/alerts_3.json /tmp/alerts_3.json
cp ./tools/4_integrations/humio/REST/alerts_4.json /tmp/alerts_4.json
cp ./tools/4_integrations/humio/REST/alerts_5.json /tmp/alerts_5.json
cp ./tools/4_integrations/humio/REST/alerts_6.json /tmp/alerts_6.json
cp ./tools/4_integrations/humio/REST/alerts_7.json /tmp/alerts_7.json

gsed -i "s/<NOTIFIER_ID>/$HUMIO_NOTIFIER_ID/" /tmp/alerts_1.json
gsed -i "s/<NOTIFIER_ID>/$HUMIO_NOTIFIER_ID/" /tmp/alerts_2.json
gsed -i "s/<NOTIFIER_ID>/$HUMIO_NOTIFIER_ID/" /tmp/alerts_3.json
gsed -i "s/<NOTIFIER_ID>/$HUMIO_NOTIFIER_ID/" /tmp/alerts_4.json
gsed -i "s/<NOTIFIER_ID>/$HUMIO_NOTIFIER_ID/" /tmp/alerts_5.json
gsed -i "s/<NOTIFIER_ID>/$HUMIO_NOTIFIER_ID/" /tmp/alerts_6.json
gsed -i "s/<NOTIFIER_ID>/$HUMIO_NOTIFIER_ID/" /tmp/alerts_7.json


curl -X "POST" "http://humio-humio-logging.$BASE_URL/api/v1/repositories/aiops/alerts" -H 'Content-Type: application/json' -H 'Authorization: Bearer '$BEARER_TOKEN -d @/tmp/alerts_1.json
curl -X "POST" "http://humio-humio-logging.$BASE_URL/api/v1/repositories/aiops/alerts" -H 'Content-Type: application/json' -H 'Authorization: Bearer '$BEARER_TOKEN -d @/tmp/alerts_2.json
curl -X "POST" "http://humio-humio-logging.$BASE_URL/api/v1/repositories/aiops/alerts" -H 'Content-Type: application/json' -H 'Authorization: Bearer '$BEARER_TOKEN -d @/tmp/alerts_3.json
curl -X "POST" "http://humio-humio-logging.$BASE_URL/api/v1/repositories/aiops/alerts" -H 'Content-Type: application/json' -H 'Authorization: Bearer '$BEARER_TOKEN -d @/tmp/alerts_4.json
curl -X "POST" "http://humio-humio-logging.$BASE_URL/api/v1/repositories/aiops/alerts" -H 'Content-Type: application/json' -H 'Authorization: Bearer '$BEARER_TOKEN -d @/tmp/alerts_5.json
curl -X "POST" "http://humio-humio-logging.$BASE_URL/api/v1/repositories/aiops/alerts" -H 'Content-Type: application/json' -H 'Authorization: Bearer '$BEARER_TOKEN -d @/tmp/alerts_6.json
curl -X "POST" "http://humio-humio-logging.$BASE_URL/api/v1/repositories/aiops/alerts" -H 'Content-Type: application/json' -H 'Authorization: Bearer '$BEARER_TOKEN -d @/tmp/alerts_7.json





#TEST

curl "$HUMIO_BASE_URL/api/v1/repositories/aiops/alertnotifiers" -H 'Content-Type: application/json' -H 'Authorization: Bearer svTejl36u9LXWlzHA8DBExKEjyrZOlWW3ul52JedMtYz' -H 'Cookie: 5aeaa98598eb11937cc50f57efd7ab5b=2f04ddcffebab6cce361fe37ec1edcb6' | grep '"id"'  | awk '{print $1}' grep '"id"'  | awk '{print $1}'
curl -X "POST" $HUMIO_BASE_URL"/api/v1/repositories/aiops/alertnotifiers" -H 'Content-Type: application/json' -H 'Authorization: Bearer '$BEARER_TOKEN -d @./tools/4_integrations/humio/REST/alertnotifiertest.json
curl -X "POST" "$HUMIO_BASE_URL/api/v1/repositories/aiops/alerts" -H 'Content-Type: application/json' -H 'Authorization: Bearer '$BEARER_TOKEN -d @./tools/4_integrations/humio/REST/alerts_test.json



