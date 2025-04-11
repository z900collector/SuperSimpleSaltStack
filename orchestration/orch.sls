#
# HA Wordpress Cluster SaltStack Orchestration File
#
# Invoke with:
# salt-run state.orch servers.wp-ha.orch
#
# Set the Cluster Grains first
# Then apply base functionality
# Then do each server by dependency ordering
# Finally, apply dynamic configuration
#
include:
  - servers.wp-ha.ha-set-all-grains

base-functionality:
  salt.state:
    - tgt: 'WP_HA_CLUSTER_MEMBER:True'
    - tgt_type: grain
    - sls:
      - roles.highstate.start
      - roles.highstate.end
      - roles.snmpd
      - roles.chronyd
      - roles.log-cleanup-script
      - roles.resolv-conf
      - roles.generate-ssh-key-script
      - roles.salt-master-key

redis-servers:
  salt.state:
    - tgt: 'WP_HA_REDIS_SERVER:True'
    - tgt_type: grain
    - highstate: True
    - require:
      - salt: base-functionality

db-servers:
  salt.state:
    - tgt: 'WP_HA_DB_SERVER:True'
    - tgt_type: grain
    - highstate: True
    - require:
      - salt: redis-servers

web-servers:
  salt.state:
    - tgt: 'WP_HA_WEB_SERVER:True'
    - tgt_type: grain
    - highstate: True
    - require:
      - salt: db-servers

hp-proxy-servers:
  salt.state:
    - tgt: 'WP_HA_HAPROXY_SERVER:True'
    - tgt_type: grain
    - highstate: True
    - require:
      - salt: web-servers
#
# Create a host key on all hosts in cluster
#
one-off-states:
  salt.state:
    - tgt: 'WP_HA_CLUSTER_MEMBER:True'
    - tgt_type: grain
    - sls:
      - servers.wp-ha.one-off-task-ssh-keygen
    - require:
      - salt: hp-proxy-servers
#
# add more here
#

#
# The dynamic component of the Orchestration
# is also called via an event.
#
dynamic-build-orch:
  salt.runner:
    - name: state.orch
    - mods: servers.wp-ha.dynamic-reconfigure  
#
# End of file
