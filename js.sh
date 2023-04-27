#! /bin/bash

target=$1
mkdir wayback 

cat $target | gau | tee wayback/gau.txt
cat $target | waybackurls | tee wayback/wayback.txt
cat wayback/gau.txt wayback/wayback.txt >> wayback/allurl.txt
rm wayback/gau.txt wayback/wayback.txt
cat wayback/allurl.txt | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l
sleep 5

echo -e "\e[1;34m [+] performing Js files scan  \e[0m"

mkdir wayback/jsfile
echo -e "Collect js,php,jsp,aspx File"

cat wayback/allurl.txt | grep -aEo 'https?://[^ ]+' | sed 's/]$//' | sort -u| grep -aEi "\.(js)" | tee wayback/jsfile/Js-file.txt

echo -e "Start Filter Js file"

cat wayback/jsfile/Js-file.txt | sort -u | httpx -content-type | grep 'application/javascript' | cut -d' ' -f1 > wayback/jsfile/Js-file200.txt
cat wayback/jsfile/Js-file200.txt | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l
httpx -l wayback/jsfile/Js-file200.txt -match-string "js.map" -o wayback/jsfile/Jsmap.txt

echo -e "Starting Js Scan"

cat wayback/jsfile/Js-file200.txt | nuclei -t /root/nuclei-templates/exposures/ -o wayback/jsfile/nucleijs.txt
cat wayback/jsfile/nucleijs.txt | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l
bash /root/mini_recon/gf.sh wayback/jsfile/Js-file200.txt | tee wayback/jsfile/gfjs.txt
