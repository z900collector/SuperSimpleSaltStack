#
# HA Wordpress Cluster
# SaltStack Orchestration File
#
# Set the Cluster Grain to target
#
{% set pillardata = salt.saltutil.runner('pillar.show_pillar', kwarg={'minion': 'localhost'}) %}

{% set WS = pillardata['web_servers'] %}
{% for M in WS %}
{{ M }}-set-ws-grain:
  salt.state:
    - tgt: {{ M }}
    - sls:
      - servers.wp-ha.grains.set-ws-grain
      - servers.wp-ha.grains.set-cluster-grain
{% endfor %}

{% set DB = pillardata['db_servers'] %}
{% for M in DB %}
{{ M }}-set-db-grain:
  salt.state:
    - tgt: {{ M }}
    - sls:
      - servers.wp-ha.grains.set-db-grain
      - servers.wp-ha.grains.set-cluster-grain
{% endfor %}

{% set RS = pillardata['redis_servers'] %}
{% for M in RS %}
{{ M }}-set-redis-grain:
  salt.state:
    - tgt: {{ M }}
    - sls:
      - servers.wp-ha.grains.set-redis-grain
      - servers.wp-ha.grains.set-cluster-grain
{% endfor %}

{% set PS = pillardata['proxy_servers'] %}
{% for M in PS %}
{{ M }}-set-haproxy-grain:
  salt.state:
    - tgt: {{ M }}
    - sls:
      - servers.wp-ha.grains.set-haproxy-grain
      - servers.wp-ha.grains.set-cluster-grain
{% endfor %}
#
# End of file
