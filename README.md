#!/bin/bash


TOTAL_MEMORY=$(free -m | grep Mem: | awk '{print $2}')
USED_MEMORY=$(free -m | grep Mem: | awk '{print $3}')
FREE_MEMORY=$(free -m | grep Mem: | awk '{print $4}')
BUFFERS_MEMORY=$(free -m | grep Mem: | awk '{print $6}')
CACHED_MEMORY=$(free -m | grep Mem: | awk '{print $7}')


#COMPUTATION

REAL_MEM_USED="$(($TOTAL_MEMORY-$FREE_MEMORY))"
MEM_PERCENTAGE="$(($REAL_MEM_USED*100/$TOTAL_MEMORY))"
details="Memory Usage: $REAL_MEM_USED MB used in the total Memory of $TOTAL_MEMORY MB ($MEM_PERCENTAGE%)"


#===================== CRITICAL STATE ====================

if [ $MEM_PERCENTAGE -ge 90 ]
then
echo "$details- CRITICAL_STATUS"

#==============EMAIL====================
TO_ADDRESS="mmquilates@philweb.com.ph"
FROM_ADDRESS="Mark.Quilates"
SUBJECT="$(date +"%Y-%m-%d-%H:%M_")MEMORY_CHECK_IN_CRITICAL_STATUS"
BODY=$(ps aux --sort -rss \n | head -n10)
echo ${BODY}| mail -s ${SUBJECT} ${TO_ADDRESS} -- -r ${FROM_ADDRESS}

exit 2


#===================== WARNING STATE ====================

elif [ $MEM_PERCENTAGE -ge 60 ] && [ $MEM_PERCENTAGE -lt 90 ]
then
echo "$details- WARNING_STATUS"



#==============EMAIL====================
TO_ADDRESS="mmquilates@philweb.com.ph"
FROM_ADDRESS="Mark.Quilates"
SUBJECT="$(date +"%Y-%m-%d-%H:%M_")MEMORY_CHECK_IN_WARNING_STATUS"
BODY=$(ps aux --sort -rss \n | head  -n10)
echo ${BODY}| mail -s ${SUBJECT} ${TO_ADDRESS} -- -r ${FROM_ADDRESS}

exit 1



else
echo "$details- OK_STATUS"
exit 0

fi
