#
# Install /etc/logrotate.conf
#
/etc/logrotate.conf:
  file.managed:
    - source: salt://roles/logrotate/logrotate.conf
    - user: root
    - group: root
    - mode: '0644'
#
# End of File
