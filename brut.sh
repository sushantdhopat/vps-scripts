#!/bin/bash


target=$1
target2=$2
#pass domain name also with the wordlist
wordlist=/root/best-dns-wordlist.txt
resolver=/root/resolvers.txt

if [ $# -gt 2 ]; then
       echo "./sub.sh <domain>"
       echo "./sub.sh google.com"
       exit 1
fi

if [ ! -d subrute ]; then
       mkdir subrute
 else
    echo "sorry we cant create the same file in same directory please remove first one subrute !!!Thanks"
    exit 1

fi


echo -e "\e[1;34m [+] performing amass on all subdomains \e[0m"
amass enum -passive -norecursive -noalts -df $target -o subrute/amasswithsub.txt

echo -e "\e[1;34m [+] Bruteforce subdomain throw puredns \e[0m"
puredns bruteforce -r $resolver $wordlist $target2 | tee subrute/bruteforce-puredns.txt

echo -e "\e[1;34m [+] Bruteforce subdomain throw dnsx \e[0m"
dnsx -silent -d $target2 -w $wordlist | tee subrute/bruteforce-dnsx.txt

echo -e "\e[1;34m [+] Bruteforce subdomain throw shuffledns \e[0m"
shuffledns -d $target2 -w $wordlist -r $resolver -o subrute/shuffledns.txt

echo -e "\e[1;34m [+] Bruteforce subdomain throw subbrute \e[0m"
python3 /root/subbrute/subbrute.py -r $resolver -s $target $target2 -o subrute/subbrute.txt

cat subrute/*.txt > subrute/unsortedresolve.txt
rm subrute/amasswithsub.txt subrute/bruteforce-puredns.txt subrute/bruteforce-dnsx.txt subrute/shuffledns.txt subrute/subbrute.txt
cat subrute/unsortedresolve.txt | sort -u | tee subrute/notresolve.txt
rm subrute/unsortedresolve.txt
