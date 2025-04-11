#!/bin/bash
#
#  Reduce cluster capacity by 1 server, keep MIN servers running.
#
#
#
# Need list of "ACTIVE"" members in cluster
# Need list of all servers possible in cluster
# Get 5min average - save highest, when it's below threshold - reduce by 1
#

LOCKFILE=/tmp/r-c-capacity.lock

source /usr/local/bin/log-functions.sh

TODAY=`date +'%Y-%m-%d'`
TMP_FILE=/tmp/wp-ha-active-hosts.txt
LOWER_LIMIT=1.0
SERVER_COUNT=0


function ReduceCapacity()
{
        LogMsg "Sending Reduce Capacity Event"
        salt-call event.send 'hacluster/capacity/remove'
}




LogStart
#----------------------------------------
#
#              M A I N
#
   SetDirectory "cluster-capacity"
   SetFilename  "reduce-capacity"
   LogInit
   LogStart
   LogMsg "Variables"
   LogMsg "           LOCKFILE = ${LOCKFILE}"
   LogMsg "             Script = $0"
   LogMsg " "
        LogMsg "Check for Lock File."
   set -C; 2>/dev/null > ${LOCKFILE}
   if [ $? -eq 1 ]
   then
      LogMsg "Lock [ ${LOCKFILE} ] exists - EXIT NOW."
      exit
   fi
   LogMsg "Set trap on exit."
   trap "rm -f ${LOCKFILE} " EXIT

   LogMsg "TODO - remove capacity"
#
# End of file
