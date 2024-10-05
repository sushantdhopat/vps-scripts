ffuf -u W2/W1 -w /Users/sushantdhopat/desktop/tech/$1:W1,$2:W2 -ac -of json -o ffuf-$2.json
cat ffuf-$2.json | jq -r '.results[] | "\(.length)"+ " " +"\(.url)" + " " + "\(.status)"' | sort -unt " " -k "1,1" | tee result-$2
rm ffuf-$2.json
