mkdir amass
domain=$1
for x in $(cat $domain)
do
amass enum -passive -norecursive -noalts -d $x | tee amass/sub.txt
done
