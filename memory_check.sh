#!/bin/bash


TOTAL_MEMORY=$(free -m | grep Mem: | awk '{print $2}')
USED_MEMORY=$(free -m | grep Mem: | awk '{print $3}')
FREE_MEMORY=$(free -m | grep Mem: | awk '{print $4}')
BUFFERS_MEMORY=$(free -m | grep Mem: | awk '{print $6}')
CACHED_MEMORY=$(free -m | grep Mem: | awk '{print $7}')


#COMPUTATION

REAL_MEM_USED="$(($TOTAL_MEMORY-$FREE_MEMORY-BUFFERS_MEMORY-CACHED_MEMORY))"
MEM_PERCENTAGE="$(($REAL_MEM_USED*100/$TOTAL_MEMORY))"
details="Memory Usage:  USED Memory $REAL_MEM_USED MB - TOTAL Memory $TOTAL_MEMORY MB ($MEM_PERCENTAGE%)"


function usage()
{
echo $0 " [-w  <warning range between 60 to 90>] [-c  <critical range between 90 to 100>] [-e  <emailaddress>]"; exit 1;
}

while getopts w:c:e: code; do
case $code in
w) w="$OPTARG";;
c) c="$OPTARG";;
e) email="$OPTARG";;
*)usage;;

esac
done
shift $((OPTIND-1))

if [ -z "${w}" ] || [ -z "${c}" ] || [ -z "${email}" ] ; then usage
fi



#===================== CRITICAL STATE ====================

if [ $MEM_PERCENTAGE -ge 90 ]
then
echo "$details- CRITICAL STATUS"

#==============EMAIL====================
TO_ADDRESS="$email"
FROM_ADDRESS="Mark.Quilates"
SUBJECT="$(date +"%Y-%m-%d-%H:%M---")Memory_Check-CRITICAL"
BODY=$(ps aux --sort -rss | head  -10)
echo ${BODY}| mail -s ${SUBJECT} ${TO_ADDRESS} -- -r ${FROM_ADDRESS}
exit 2



#===================== WARNING STATE ====================

elif [ $MEM_PERCENTAGE -ge 60 ] && [ $MEM_PERCENTAGE -lt 90 ]
then
echo "$details- WARNING STATUS"

#==============EMAIL====================
TO_ADDRESS="$email"
FROM_ADDRESS="Mark.Quilates"
SUBJECT="$(date +"%Y-%m-%d-%H:%M---")Memory_Check-WARNING"
BODY=$(ps aux --sort -rss | head  -10)
echo ${BODY}| mail -s ${SUBJECT} ${TO_ADDRESS} -- -r ${FROM_ADDRESS}
exit 1



else
echo "$details- OK"
exit 0

fi

