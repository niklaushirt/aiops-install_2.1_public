  echo "Simulating Bookinfo Ratings outage"



input="./demo/kubetoy/error_event.json"
while IFS= read -r line
do
  export my_timestamp=$(date +%s)000
  echo "Injecting Event at: $my_timestamp"

  curl --insecure -X "POST" "$NETCOOL_WEBHOOK" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896' \
     -d $"${line}"
  echo "----"
done < "$input"

echo "Done"


