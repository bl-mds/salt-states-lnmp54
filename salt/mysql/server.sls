mysql:
  pkg.installed:
    - name: mysql-server
    - require:
      - cmd: remove-mysql-libs
  service.running:
    - name: mysqld
    - enable: True
    - require:
      - pkg: mysql-server
      - cmd: mysql-db-init
    - watch:
      - pkg: mysql-server
      - file: /etc/my.cnf

remove-mysql-libs:
  cmd.run:
    - name: rpm -e --nodeps mysql-libs
    - onlyif: rpm -qa |grep mysql-libs

mysql-db-init:
  cmd.run:
    - name: mkdir -p /data/mysql/{data,tmp,run,binlog,log,relaylog} && chown -R mysql:mysql /data/mysql/{data,tmp,run,binlog,log,relaylog} && mysql_install_db --user=mysql --datadir=/data/mysql/data/
    - unless: test -d /data/mysql/
 
/etc/my.cnf:
  file.managed:
    - source: salt://mysql/files/etc/my.cnf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
