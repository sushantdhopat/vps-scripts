#!/bin/bash


target=$1
target2=$2
#pass domain name also with the wordlist
wordlist=/root/best-dns-wordlist.txt
altdnswords=/root/altdns.txt
perm=/root/dirbrut/perm-word.txt
resolver=/root/resolvers.txt

if [ $# -gt 2 ]; then
       echo "./sub.sh <domain>"
       echo "./sub.sh google.com"
       exit 1
fi

if [ ! -d perm ]; then
       mkdir perm
 else
    echo "sorry we cant create the same file in same directory please remove first one perm !!!Thanks"
    exit 1

fi

echo -e "\e[1;34m [+] Bruteforce subdomain throw altdns \e[0m"
altdns -i $target -w $altdnswords -o perm/altdns.txt

echo -e "\e[1;34m [+] Running dnsgen -perm \e[0m"
cat $target | dnsgen -w $perm - | tee perm/dnsgen.txt

echo -e "\e[1;34m [+] Running gotator -perm \e[0m"
timeout 1h gotator -sub $target -perm $perm -depth 3 -numbers 10 -md | uniq | tee perm/gotator.txt

cat perm/*.txt > perm/unsortedresolve.txt
rm perm/altdns.txt perm/dnsgen.txt perm/gotator.txt
cat perm/unsortedresolve.txt | sort -u | tee perm/notresolve.txt
rm perm/unsortedresolve.txt
