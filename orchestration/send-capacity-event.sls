#
# send-capacity-event.sls
#
{% set tstamp = grains.get('time')|strftime('%s') %}


hacluster/capacity/check:
  event.send:
    - data:
        ts: {{tstamp}}
#
# End of file
