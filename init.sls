#
# HA Proxy VM for NGINX (wordpress) sites
# Build: 2025-01-09
#
include:
  - roles.resolv-conf
  - roles.motd
  - roles.logrotate
  - roles.sysstat
  - roles.generate-ssh-key-script
  - roles.metrics.load-ave
  - roles.metrics.df-to-json
  - roles.metrics.memory
  - roles.metrics.cleanup
  - roles.snmpd.service-monitoring.firewalld
  - users.bob
  - users.alice
  - roles.salt-master-key
  - .hosts
  - .packages
  - .haproxy
  - roles.firewalld.prtg
  - roles.firewalld.http
  - roles.firewalld.https
  - roles.firewalld.ictssh
  - .beacons
  - .cron
  - .secure-firewalld
#
# End of File
