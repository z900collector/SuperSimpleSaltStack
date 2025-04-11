/etc/resolv.conf:
  file.managed:
    - source: salt://roles/resolv-conf/resolv.conf
    - user: root
    - group: root
    - mode: 644
