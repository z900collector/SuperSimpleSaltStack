#
# send-recheck-event.sls
#
{% set tstamp = grains.get('time')|strftime('%s') %}


hacluster/capacity/recheck:
  event.send:
    - data:
        ts: {{tstamp}}
#
# End of file
