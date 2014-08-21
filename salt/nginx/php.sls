php-fpm:
  pkg.installed:
    - name: php-fpm
    - pkgs:
      - php-fpm
      - php-common
      - php-cli
      - php-pecl-memcache
      - php-pecl-memcached
      - php-gd
      - php-pear
      - php-mcrypt
      - php-mbstring
      - php-mysqlnd
      - php-xml
      - php-bcmath
      - php-pdo
  service.running:
    - name: php-fpm
    - enable: True
    - require:
      - pkg: php-fpm
    - watch:
      - pkg: php-fpm
      - file: /etc/php.ini
      - file: /etc/php.d/
      - file: /etc/php-fpm.conf
      - file: /etc/php-fpm.d/

/etc/php.ini:
  file.managed:
    - source: salt://nginx/files/etc/php.ini
    - user: root
    - group: root
    - mode: 644

/etc/php.d/:
  file.recurse:
    - source: salt://nginx/files/etc/php.d/
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644

/etc/php-fpm.conf:
  file.managed:
    - source: salt://nginx/files/etc/php-fpm.conf
    - user: root
    - group: root
    - mode: 644

/etc/php-fpm.d/:
  file.recurse:
    - source: salt://nginx/files/etc/php-fpm.d/
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
