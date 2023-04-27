#!/bin/bash

echo -e "\e[1;32m "
target=$1

if [ $# -gt 2 ]; then
       echo "./sub.sh <domain>"
       echo "./sub.sh google.com"
       exit 1
fi

if [ ! -d wayback ]; then
       mkdir wayback
 else
    echo "sorry we cant create the same file in same directory please remove first one wayback !!!Thanks"
    exit 1

fi

echo -e "\e[1;34m [+] performing wayback  \e[0m"

cat $target | gau | tee wayback/gau.txt
cat $target | waybackurls | tee wayback/wayback.txt
katana -list $target | tee wayback/katana.txt
gospider -S $target -o wayback/gospider.txt -c 10 -d 1 --other-source --include-subs --blacklist
cat $target | hakrawler | tee wayback/hakrawler.txt
cat wayback/gau.txt wayback/wayback.txt wayback/katana.txt wayback/gospider.txt wayback/hakrawler.txt >> wayback/urls.txt
rm wayback/gau.txt wayback/wayback.txt wayback/katana.txt wayback/gospider.txt wayback/hakrawler.txt
cat wayback/urls.txt | sort -u | tee wayback/allurl.txt
rm wayback/urls.txt
cat wayback/allurl.txt | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l
sleep 5
#api endpoint 
echo -e "Starting Collect Api-Endpoint"
cat wayback/allurl.txt | grep -i "/api/" | sort -u | tee wayback/apiend.txt
cat wayback/apiend.txt  | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l
sleep 5

echo -e "\e[1;34m [+] performing Js files scan  \e[0m"

mkdir wayback/jsfile
echo -e "Collect js,php,jsp,aspx File"

cat wayback/allurl.txt | grep -aEo 'https?://[^ ]+' | sed 's/]$//' | sort -u| grep -aEi "\.(js)" | tee wayback/jsfile/Js-file.txt
cat wayback/jsfile/Js-file.txt | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l
cat wayback/allurl.txt | grep -aEo 'https?://[^ ]+' | sed 's/]$//' | sort -u| grep -aEi "\.(php)" | tee wayback/jsfile/PHP-file.txt
cat wayback/jsfile/PHP-file.txt  | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l
cat wayback/allurl.txt | grep -aEo 'https?://[^ ]+' | sed 's/]$//' | sort -u| grep -aEi "\.(aspx)" | tee wayback/jsfile/aspx-file.txt
cat wayback/jsfile/aspx-file.txt | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l
cat wayback/allurl.txt | grep -aEo 'https?://[^ ]+' | sed 's/]$//' | sort -u| grep -aEi "\.(jsp)" | tee wayback/jsfile/Jsp-file.txt
cat wayback/jsfile/Jsp-file.txt | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l

echo -e "Start Filter Js file"

cat wayback/jsfile/Js-file.txt | sort -u | httpx -content-type | grep 'application/javascript' | cut -d' ' -f1 > wayback/jsfile/Js-file200.txt
cat wayback/jsfile/Js-file200.txt | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l
httpx -l wayback/jsfile/Js-file200.txt -match-string "js.map" -o wayback/jsfile/Jsmap.txt

echo -e "Starting Js Scan"

cat wayback/jsfile/Js-file200.txt | nuclei -t /root/nuclei-templates/exposures/ -o wayback/jsfile/nucleijs.txt
cat wayback/jsfile/nucleijs.txt | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l
