#
# OS platform is RHEL/Oracle Linux 8.10, enable the repo's so the package can be downloaded.
#
enable-ol8_codeready_builder:
  pkgrepo.managed:
    - name: ol8_codeready_builder
    - enabled: True

enable-ol8_addons:
  pkgrepo.managed:
    - name: ol8_addons
    - enabled: True
#
# Install and start the HA Proxy
#
haproxy:
  pkg:
    - installed
  service.running:
    - name: haproxy
    - enable: True
    - require:
      - pkg: haproxy

/etc/haproxy/conf.d:
  file.directory:
    - mode: '0775'

/etc/haproxy/conf.d/haproxy.cfg:
  file.rename:
    - name: /etc/haproxy/conf.d/haproxy.cfg.original
    - source: /etc/haproxy/haproxy.cfg
#
# Debug code to output the list the SLS file thinks it has.
#
{% set pillardata = pillar['web_servers'] %}
write-pillar-file:
  file.managed:
    - name: /tmp/pillardata.txt
    - contents:
      - {{ pillardata }}
#
# Our JINJA template haproxy.cfg file.
#
/etc/haproxy/haproxy.cfg:
  file.managed:
    - name: /etc/haproxy/haproxy.cfg
    - source: salt://servers/{{pillar['server_name']}}/files/haproxy.cfg.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'
  service.running:
    - name: haproxy
    - watch:
      - file: '/etc/haproxy/haproxy.cfg'
#
# End of File
