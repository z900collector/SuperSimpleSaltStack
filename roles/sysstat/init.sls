#
# Download SysStat (sar) config
#
sysstat-install:
  pkg.installed:
    - name: sysstat

/etc/cron.d/sysstat:
  file.managed:
    - source: salt://roles/sysstat/sysstat.crond
    - user: root
    - group: root
    - mode: 600

/etc/sysconfig/sysstat:
  file.managed:
    - source: salt://roles/sysstat/sysstat.sysconfig
    - user: root
    - group: root
    - mode: 644

sysstat:
  service.running:
    - enable: true
    - reload: true
#
# End of file
