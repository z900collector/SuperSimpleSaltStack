#
# Schedule the capacity check EVENT every minute
#
hacluster-check-capacity:
  schedule.present:
    - function: state.sls
    - job_args:
      - servers.wp-haproxy-01.send-capacity-event
    - minutes: 1
#
# Schedule the re-check EVENT every 5 minutes:
#
re-check-capacity:
  schedule.present:
    - function: state.sls
    - job_args:
      - servers.wp-haproxy-01.send-recheck-event
    - minutes: 4
#
# End of file
