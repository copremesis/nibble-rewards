#!/bin/bash

export port=3000
export host="http://localhost:$port"
export to="robert.a.ortiz@gmail.com"
export USER='rob@dragonwrench.com'
export PASS='m0r3b33rS'

#sign in using Curl to obtain token

echo $'\nPOST' $host/api/users/sign_in
export token=$(
  curl -s -H "Accept: application/json" \
          -H "Content-Type: application/json" \
          -X POST $host/api/users/sign_in  \
          -d "{\"user\":{\"email\":\"$USER\",\"password\":\"$PASS\"}}"  \
          | python -mjson.tool | grep token | cut -d: -f2 | sed 's/ *[",]*//g'  \

)
echo "User's token:"
echo $token

#email notification

time curl -s -H "Accept: application/json"  \
             -H "Content-Type: application/json"  \
             -H "x-auth-token: $token"  \
             -X POST $host/api/email  \
             -d "{\"from\":\"no_reply%40195ccfa3063df0dfd5dc177cc68b42bf.com\",\"to\":\"$to\",\"cc\":\"\",\"bcc\":\"\",\"subject\":\"testing cURL transaction\",\"body\":\"this is a test\"}" | python -mjson.tool


echo 'Logging out...' && sleep $sleep
echo $'\nDELETE' $host/api/users/sign_out
curl -s -H "Accept: application/json"  \
        -H "Content-Type: application/json"  \
        -H "x-auth-token: $token" \
        -X DELETE $host/api/users/sign_out  \
        | python -mjson.tool

exit

#sms
#requires an upgrade through send in blue

curl -H 'api-key:THE_SMS_KEY' -X POST -d '{"text":"Good morning - test","tag":"Tag1","web_url":"","from":"From","to":"+1XXXXXXXXX","type":"transactional"}' 'https://api.sendinblue.com/v2.0/sms' | python -m json.tool

