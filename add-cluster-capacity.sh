#!/bin/bash
#
# Add Cluster capacity
#
# Add an extra server to the list of servers listed in the pillar data for "web_servers".
# Must already have entries in all other fields to ensure everything is initially
# configured when the cluster was built.
#
# set a lockfile to ensure we do not re-trigger

LOCKFILE=/tmp/add-ha-capacity.lock
ADD_IN_PROGRESS_LOCKFILE=/tmp/add-remove-flag.lock

source /usr/local/bin/log-functions.sh

TODAY=`date +'%Y-%m-%d'`
TMP_FILE=/tmp/wp-ha-hosts.txt
LIMIT=1.0
SERVER_COUNT=0
LOADED_SERVERS=0

LogStart
#----------------------------------------
#
#              M A I N
#
   SetDirectory "cluster-capacity"
   SetFilename  "add-capacity"
   LogInit
   LogStart
   LogMsg "Variables"
   LogMsg "           TMP_FILE = ${TMP_FILE}"
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


        LogMsg "TODO - add capacity"


        LogEnd
#
# End of file
