#!/bin/bash
#
# Given a list of active web servers (passed in as pillar data
# inside the reactor script), determine the load average of
# each as well as the combined average and work out if MORE
# capacity is needed.
# IF MORE, trigger an event to ADD More Capacity
# and then that process can signal a reconfigure event.
#
# set a lockfile to ensure we do not re-trigger

LOCKFILE=/tmp/check-ha-capacity.lock

source /usr/local/bin/log-functions.sh

TODAY=`date +'%Y-%m-%d'`
TMP_FILE=/tmp/wp-ha-hosts.txt
LIMIT=1.10
SERVER_COUNT=0
LOADED_SERVERS=0

#----------------------------------------
#
# Send Event to request capacity
# NOTE:
# Once extra server is added, its load will be 0 so capacity request
# should stop as it handles the extra load.
# If it becomes loaded then we are back here.
# If ADD script waits then successive calls should fail till it completes.
#
function RequestCapacity()
{
        LogMsg "RequestCapacity()"
        salt-call event.send 'hacluster/capacity/add'
}


#----------------------------------------
#
#
function NoLoad()
{
        LogMsg "NoLoad() - Do Nothing"
}




#----------------------------------------
#
# Inc LOADED value if we need capacity
#
function NeedCapacity()
{
        LogMsg "NeedCapacity()"
        ((LOADED_SERVERS++))
        LogMsg "Total Servers [ ${SERVER_COUNT} ] -> Loaded [ ${LOADED_SERVERS} ]"
        LogMsg "${LOADED_SERVERS} of ${SERVER_COUNT} servers have a load average greater than ${LIMIT} "
}

#----------------------------------------
#
#              M A I N
#
   SetDirectory "cluster-capacity"
   SetFilename  "check-every-minute"
   LogInit
#   LogStart
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

        SERVERS=($@)
        #
        # Extract a clean list of active web servers from CLI
        #
        rm -f ${TMP_FILE}
        SERVER_COUNT=0
        LogMsg "Extract servers"
        for SERVER in "${SERVERS[@]}"
        do
            echo ${SERVER//,}|sed "s/\[//"|sed "s/\]//" >> ${TMP_FILE}
                 ((SERVER_COUNT++))
        done
        LogMsg "There are ${SERVER_COUNT} server entries"

        #
        # for each server, check the load average already recorded by the Engine
        #
        while read -r host_id
        do
                LogMsg " "
                LogMsg "Check for [ ${host_id} ] log file"
                log_file=/data/self-heal/load/${host_id}-load-${TODAY}.log
                if [ -f $log_file ]
                then
                        LogMsg "Get number of entries for [ ${host_id} ]"
                        line_cnt=`cat ${log_file}|wc -l`
                        LogMsg "Log file for ${host_id} has ${line_cnt} entries"
                        LINE=`tail -1 $log_file`
                        M1=`echo ${LINE}|cut -d"|" -f3`
                        M5=`echo ${LINE}|cut -d"|" -f4`
                        M15=`echo ${LINE}|cut -d"|" -f5`

                        LogMsg "M1=${M1}  M5=${M5}  M15=${M15}"
                        if (( $(echo "$M1 > $LIMIT" |bc -l) ))
                        then
                                LogMsg "Load Average M1 is OVER limit ${M1} > ${LIMIT}"
                                NeedCapacity
                        else
                                NoLoad
                        fi
                else
                        LogMsg "Log file not present - is Engine installed?"
                fi
        done <  ${TMP_FILE}
        #
        # Now do final check if LOADED_SERVERS == SERVER_COUNT
        # Then all servers are loaded!
        #
        if [ "$LOADED_SERVERS" -eq "$SERVER_COUNT" ]
        then
                RequestCapacity
        else
                LogMsg "Not all servers are loaded"
        fi
##      LogEnd
#
# End of file
